# frozen_string_literal: true

class RefreshMaterializedViewsJob < ApplicationJob
  def perform(view_name)
    views = ActiveRecord::Base.connection.views.map { |t| t.capitalize.singularize.titleize }

    if views.include?(view_name)
      view_name.constantize.refresh
    end
  end
end