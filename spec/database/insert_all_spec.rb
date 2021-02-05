require 'rails_helper'
require 'csv'

# insert_all was introduced on Rails 6.
# For previous versions, try https://github.com/zdennis/activerecord-import
RSpec.describe '#insert_all' do
  fixtures :brands

  let(:file) { file_fixture("cars.csv").read }

  context 'iteration' do
    it do
      expect {
        CSV.parse(file, headers: true) do |row|
          next if row['brand'].blank?
          Car.create!(name: row['name'], brand: brands[row['brand'].strip])
        end
      }.to perform_under(15).sec.warmup(0).sample(1)
    end
  end

  context 'insert_all' do
    it do
      expect {
        cars = CSV.parse(file, headers: true).map do |row|
          next if row['brand'].blank?
          { name: row['name'], brand_id: brands[row['brand'].strip].id }
        end

        # For this to work, you have to set CURRENT_TIMESTAMP for timestamp fields.
        # See db/migrate/20210205021123_add_current_timestamp_default.rb
        Car.insert_all(cars.compact, unique_by: :index_car_name_brand_id, returning: %i[id name brand_id])
      }.to perform_under(1).sec.warmup(0).sample(1)
    end
  end

  def brands
    @brands ||= Hash[Brand.all.map{ |b| [b.name, b] }]
  end
end
