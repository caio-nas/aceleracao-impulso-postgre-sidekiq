class CreateSellers < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :email

      t.timestamps
      t.index %w[name email], unique: true
    end
  end
end
