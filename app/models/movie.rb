class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    if ratings_list.nil? || ratings_list.empty?
      all
    else
      where(rating: ratings_list)
    end
  end

  def self.all_ratings
    pluck(:rating).uniq
  end

  def self.sorted_by(column)
    if column.nil?
      Movie.all
    else
      Movie.order(column)
    end
  end
  
end


