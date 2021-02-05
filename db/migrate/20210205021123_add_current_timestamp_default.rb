class AddCurrentTimestampDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :cars, :created_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :cars, :updated_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :brands, :created_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :brands, :updated_at, from: nil, to: -> { 'CURRENT_TIMESTAMP' }
  end
end
