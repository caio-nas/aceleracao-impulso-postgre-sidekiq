class Buyer < ApplicationRecord
  validates_uniqueness_of :email, scope: %i[name]
end
