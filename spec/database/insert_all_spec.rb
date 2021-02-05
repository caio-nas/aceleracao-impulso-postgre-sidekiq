require 'rails_helper'
require 'csv'

# insert_all was introduced on Rails 6.
# For previous versions, try https://github.com/zdennis/activerecord-import
RSpec.describe '#insert_all' do
  fixtures :brands
  let(:file) { file_fixture('cars.csv').read }
  let(:csv)  { CSV.parse(file, headers: true) }

  context 'comparing with iteration' do
    context 'iteration' do
      it do
        expect {
          car_hashes_from_csv.each do |car_attrs|
            Car.create!(car_attrs)
          end
        }.to perform_under(15).sec.warmup(0).sample(1)
      end
    end

    context 'insert_all' do
      it do
        expect {
          # For this to work, you have to set CURRENT_TIMESTAMP for timestamp fields.
          # See db/migrate/20210205021123_add_current_timestamp_default.rb
          Car.insert_all(car_hashes_from_csv, unique_by: :index_car_name_brand_id)
        }.to perform_under(1).sec.warmup(0).sample(1)
      end
    end
  end

  context 'when the database has duplicates' do
    let(:duplication_size) { 5 }

    before do
      Car.insert_all!(car_hashes_from_csv.sample(duplication_size))
    end

    context 'insert_all' do
      it 'skips duplicates' do
        cars = car_hashes_from_csv

        created = Car.insert_all(cars, unique_by: :index_car_name_brand_id, returning: %i[id name])
        expect(created.count).to eq(cars.count - duplication_size)
      end
    end

    context 'insert_all!' do
      it 'raises error' do
        cars = car_hashes_from_csv

        # the bang variation does not accept unique_by parameter, just database unique indexes
        expect{ Car.insert_all!(cars, returning: %i[id]) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  private

  def brands
    @brands ||= Hash[Brand.all.map{ |b| [b.name, b] }]
  end

  def car_hashes_from_csv
    @car_hashes_from_csv = csv.map do |row|
      next if row['brand'].blank?
      { name: row['name'], brand_id: brands[row['brand'].strip].id }
    end.compact
  end
end
