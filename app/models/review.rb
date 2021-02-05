class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewer, polymorphic: true

  scope :reviewable, ->(reviewable_type) { where(reviewable_type: reviewable_type) }
end
