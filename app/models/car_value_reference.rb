class CarValueReference < ApplicationRecord
  belongs_to :car

  validates :competency, :value, presence: true
end
