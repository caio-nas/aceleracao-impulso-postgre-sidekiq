module MaterializedView
  extend ActiveSupport::Concern

  class_methods do
    def refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end

    def enqueue_refresh
      RefreshMaterializedViewsJob.perform_later(table_name.capitalize.singularize.titleize)
    end
  end
end