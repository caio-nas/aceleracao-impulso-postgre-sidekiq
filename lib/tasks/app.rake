# frozen_string_literal: true

require 'csv'

def time_rand(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end

def value_rand(from = 1, to = 180_000)
  rand(from..to).to_f
end

task load_brands: :environment do
  fixture_path = 'spec/fixtures/files/brands.csv'
  brands = CSV.foreach(Rails.root.join(fixture_path), headers: true)
  Brand.upsert_all(brands.map { |b| { name: b['name'] } }, unique_by: :index_brands_on_name)
end

task load_cars: :environment do
  brands = Brand.select(:id, :name).all

  def find_brand_by_name(name, brands)
    brands.find { |b| b.name == name }
  end

  fixture_path = 'spec/fixtures/files/cars.csv'

  cars = CSV.foreach(Rails.root.join(fixture_path), headers: true).map do |car_row|
    next if car_row['brand'].blank?

    { name: car_row['name'].strip, brand_id: find_brand_by_name(car_row['brand'].strip, brands)&.id }
  end.compact

  Car.insert_all(cars, unique_by: :index_car_name_brand_id)
end

task generate_car_value_references: :environment do
  cars = Car.pluck(:id)

  value_references = cars.map do |car_id|
    { car_id: car_id, competency: time_rand, value: value_rand }
  end

  CarValueReference.insert_all(value_references)
end

task generate_sales: :environment do
  15.times do
    car = Car.order('RANDOM()').first
    buyer = Buyer.order('RANDOM()').first
    seller = Seller.order('RANDOM()').first
    dates = (Date.new(2020, 1, 1)..Date.new(2021, 12, 1)).to_a
    car.sell!(buyer: buyer, seller: seller, closed_at: dates.sample)
  end
end

task generate_reviews: :environment do
  reviewables = [Car.all, Brand.all].flatten.sort_by(&:created_at)
  reviewers = [Buyer.all, Seller.all].flatten.sort_by(&:created_at)

  500.times do
    Review.create(reviewable: reviewables.sample, reviewer: reviewers.sample, content: FFaker::Lorem.paragraphs(20).join("\n"))
  end
end
