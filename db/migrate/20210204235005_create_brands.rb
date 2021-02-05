class CreateBrands < ActiveRecord::Migration[6.0]
  def change
    create_table :brands do |t|
      t.string :name, null: false

      t.timestamps
      t.index %w[name], unique: true
    end
  end
end
