require 'ruby-tmdb'

class Movie < ActiveRecord::Base
  
  class Movie::InvalidKeyError < StandardError; end
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.api_key
    'cc4b67c53acb514bdf4931f7cedfd12b'
  end
  
  def name_with_rating
    "#{self.title} (#{self.rating})"
  end
  
  def self.find_in_tmdb(title)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => title)
    rescue ArgumentError => tmdb_error
      raise Movie::InvalidKeyError, tmdb_error.message
    rescue RuntimeError => tmdb_error
      if tmdb_error.message =~/status code '404'/
        raise Movie::InvalidKeyError, tmdb_error.message
      else
        raise RuntimeError, tmdb_error.message
      end
    end
    
  end
end
