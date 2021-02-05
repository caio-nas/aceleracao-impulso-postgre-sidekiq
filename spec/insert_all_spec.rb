require 'rails_helper'
require 'csv'

RSpec.describe '#insert_all' do
  before do
    CSV.foreach(file_fixture("marcas_carros.csv"), headers: true) do |row|
      Brand.create!(row.to_h)
    end
  end

  let(:file) { file_fixture("carros.csv").read }

  context 'iteration' do
    it do
      # expect {
        # CSV.parse(file, headers: true) do |row|
        #   p row
        #   next if row['brand'].blank?

        #   p row['id']
        #   Car.create!(name: row['name'], brand: brands[row['brand'].strip])

        1.upto(6).each do |i|
          p i
        end
      # }.to perform_under(15).sec.sample(1)
    end
  end

  context 'insert_all' do
    let(:csv) { CSV.foreach(file, headers: true) }

    it do
      expect {
        cars = csv.map do |row|
          next if row['brand'].blank?

          { name: row['name'], brand_id: brands[row['brand'].strip].id }
        end

        Car.insert_all(cars, unique_by: :index_car_name_brand_id, returning: %i[id name brand_id])
      }.to perform_under(10).ms
    end
  end

  def brands
    @brands ||= Hash[Brand.all.map{ |b| [b.name, b] }]
  end
end


# class ImportCars
#   attr_accessor :csv, :brands

#   def csv
#     @csv ||= CSV.foreach('tmp/carros.csv', headers: true)
#   end

#   def brands
#     @brands ||= brand.all
#   end

#   def find_brand_by_name(name)
#     brands.find { |brand| brand.name == name }
#   end

#   def import!
#     csv.each do |row|
#       next if row['brand'].blank?

#       car = Car.find_or_initialize_by(name: row['name'])
#       car.brand = find_brand_by_name(row['brand'].strip)
#       car.save!
#     end
#   end

#   def bulk_import!
#     cars = []
#     csv.each do |row|
#       next if row['brand'].blank?

#       cars << { name: row['name'], brand_id: find_brand_by_name(row['brand'].strip).id }
#     end

#     Car.insert_all(cars, unique_by: :index_cars, returning: %i[id name brand_id])
#   end
# end
