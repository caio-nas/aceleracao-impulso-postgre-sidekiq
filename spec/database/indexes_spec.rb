require 'rails_helper'
require 'csv'

RSpec.describe 'Indexes' do
  before(:all) do
    DatabaseCleaner.start
    Brand.upsert_all(brand_hashes_from_csv)
    Car.upsert_all(car_hashes_from_csv)
  end

  after(:all) do
    DatabaseCleaner.clean
  end

  let(:random_car) { Car.where.not(serial_number: nil).sample }

  context 'exact matches' do
    context 'without index' do
      it do
        expect {
          Car.where(serial_number: random_car.serial_number)
        }.to perform_under(1).ms.warmup(1).sample(10)
      end
    end

    context 'btree index' do
      it do
        expect {
          Car.where(serial_number_index_btree: random_car.serial_number)
        }.to perform_under(1).ms.warmup(1).sample(10)
      end
    end

    context 'hash index' do
      it do
        expect {
          Car.where(serial_number_index_hash: random_car.serial_number)
        }.to perform_under(1).ms.warmup(1).sample(10)
      end
    end
  end

  context 'partial matches' do
    context 'without index' do
      it do
        expect {
          Car.where("serial_number LIKE '%?%'": random_car.serial_number[0..2])
        }.to perform_under(1).ms.warmup(1).sample(10)
      end
    end

    context 'btree index' do
      it do
        expect {
          Car.where("serial_number_index_btree LIKE '%?%'": random_car.serial_number[0..2])
        }.to perform_under(1).ms.warmup(1).sample(10)
      end
    end

    context 'hash index' do
      it do
        expect {
          Car.where("serial_number_index_hash LIKE '%?%'": random_car.serial_number[0..2])
        }.to perform_under(1).ms.warmup(1).sample(10)
      end
    end
  end

  private

  def brands
    @brands ||= Hash[Brand.all.map{ |b| [b.name, b] }]
  end

  def car_hashes_from_csv
    file =file_fixture('cars.csv').read
    csv = CSV.parse(file, headers: true)

    @car_hashes_from_csv = csv.map do |row|
      next if row['brand'].blank?
      uuid = SecureRandom.uuid.split('-').first

      {
        id: row['id'],
        name: row['name'],
        brand_id: brands[row['brand'].strip].id,
        score: rand(1..100,),
        active: [true, false].sample,
        serial_number: uuid,
        serial_number_index_btree: uuid,
        serial_number_index_hash: uuid,
      }
    end.compact
  end

  def brand_hashes_from_csv
    file =file_fixture('brands.csv').read
    csv = CSV.parse(file, headers: true)

    @brand_hashes_from_csv = csv.map do |row|
      next if row['name'].blank?
      { id: row['id'], name: row['name'] }
    end.compact
  end
end
