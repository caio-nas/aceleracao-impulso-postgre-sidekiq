class Sale < ApplicationRecord
  belongs_to :car
  belongs_to :seller
  belongs_to :buyer
  belongs_to :car_value_reference
end
