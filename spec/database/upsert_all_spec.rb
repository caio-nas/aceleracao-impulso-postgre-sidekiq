require 'rails_helper'
require 'csv'

# upsert_all was introduced on Rails 6.
# For previous versions, try https://github.com/zdennis/activerecord-import
RSpec.describe '#upsert_all' do
  fixtures :brands
  let(:file) { file_fixture('cars.csv').read }
  let(:csv)  { CSV.parse(file, headers: true) }
  let(:duplication_size) { 5 }

  before do
    original = car_hashes_from_csv
      .sample(duplication_size)
      .map{ |car| car.update(name: "[ORIGINAL] #{car[:name]}") }

    Car.insert_all!(original)
  end

  context 'comparing with iteration' do
    context 'iteration' do
      it do
        expect {
          expect(unchanged_entries).to eq(duplication_size)

          car_hashes_from_csv.each do |car_attrs|
            Car.upsert(car_attrs)
          end

          expect(unchanged_entries).to eq(0)
        }.to perform_under(5).sec.warmup(0).sample(1)
      end
    end

    context 'upsert_all' do
      it do
        expect {
          expect(unchanged_entries).to eq(duplication_size)

          Car.upsert_all(car_hashes_from_csv)

          expect(unchanged_entries).to eq(0)
        }.to perform_under(1).sec.warmup(0).sample(1)
      end
    end
  end

  private

  def brands
    @brands ||= Hash[Brand.all.map{ |b| [b.name, b] }]
  end

  def unchanged_entries
    Car.where("name LIKE '[ORIGINAL]%'").count
  end

  def car_hashes_from_csv
    @car_hashes_from_csv = csv.map do |row|
      next if row['brand'].blank?
      { id: row['id'], name: row['name'], brand_id: brands[row['brand'].strip].id }
    end.compact
  end
end
