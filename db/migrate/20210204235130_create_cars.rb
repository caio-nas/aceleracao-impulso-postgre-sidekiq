class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.string :name, unique: true, null: false
      t.references :brand, null: false, foreign_key: true, index: false

      t.timestamps
      t.index %i[name brand_id], name: 'index_car_name_brand_id', unique: true
    end
  end
end
