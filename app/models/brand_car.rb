class BrandCar
  include StoreModel::Model

  attribute :id, :integer
  attribute :name, :string
  attribute :value, :decimal
end