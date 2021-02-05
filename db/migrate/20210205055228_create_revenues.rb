class CreateRevenues < ActiveRecord::Migration[6.0]
  def change
    create_view :revenues, materialized: true
  end
end
