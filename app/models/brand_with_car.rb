class BrandWithCar < ApplicationRecord
  include MaterializedView
  default_scope { order(id: :asc) }

  attribute :cars, BrandCar.to_array_type
end
