class Revenue < ApplicationRecord
  include MaterializedView
  default_scope { order(competency: :asc) }
end
