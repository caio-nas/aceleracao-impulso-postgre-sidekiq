class BlogPost < ApplicationRecord
  validates :title, presence: true

  class << self
    def search(query)
      where("search @@ to_tsquery('english', ?)", query)
    end

    def ordered_search(query, direction: 'DESC')
      mapped_query = sanitize_sql_array ["to_tsquery('english', ?)", query]
      condition = "search @@ #{mapped_query}"
      order = "ts_rank_cd(search, #{mapped_query}) #{direction}"
      where(condition).order(order)
    end
  end
end
