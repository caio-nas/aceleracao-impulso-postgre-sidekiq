class CreateCarValueReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :car_value_references do |t|
      t.references :car, null: false, foreign_key: true, index: true
      t.date :competency, null: false
      t.decimal :value, precision: 14, scale: 2

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
      t.index %w[competency]
    end
  end
end
