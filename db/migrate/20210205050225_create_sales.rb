class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.references :car, null: false, foreign_key: true, index: true
      t.references :seller, null: false, foreign_key: true, index: true
      t.references :buyer, null: false, foreign_key: true, index: true
      t.references :car_value_reference, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
