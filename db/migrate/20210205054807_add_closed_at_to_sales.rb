class AddClosedAtToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :closed_at, :timestamp, null: true
  end
end
