class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_similar_movies(id)
    movie=self.find(id)
    if(movie.director==nil || movie.director.length==0)
      return [[],1,movie]
    else
      moviesall=Movie.where(director: movie.director)
      return [moviesall,0,movie]
    end
  end
end 
