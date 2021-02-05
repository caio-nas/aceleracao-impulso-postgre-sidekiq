class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :reviewable, foreign_key: false, polymorphic: true, index: true
      t.references :reviewer, foreign_key: false, polymorphic: true, index: true

      t.text :content
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
