class Brand < ApplicationRecord
  has_many :cars
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :name, presence: true
end
