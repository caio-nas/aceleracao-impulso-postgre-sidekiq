class CreateBrandWithCars < ActiveRecord::Migration[6.0]
  def change
    create_view :brand_with_cars, materialized: true
  end
end
