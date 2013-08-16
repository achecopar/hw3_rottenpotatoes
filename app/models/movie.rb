class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  def self.search(search_term,search_value)
	where(search_term=>search_value)
  end
end
