class Car < ApplicationRecord
  belongs_to :brand

  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :name, presence: true

  scope :with_reviews,-> {
    reviewable_cars_sql = Review.count.reviewable('Car').where('"reviews"."reviewable_id" = "cars".id').to_sql
    having("(#{reviewable_cars_sql}) > ?", 1).group(:id)
  }
end
