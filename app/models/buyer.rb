class Buyer < ApplicationRecord
  has_many :sales
  has_many :reviews, as: :reviewer, dependent: :destroy

  validates :name, :email, presence: true
  validates_uniqueness_of :email, scope: %i[name]
end
