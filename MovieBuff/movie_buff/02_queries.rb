def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between
  # 3 and 5 (inclusive).
  # Show the id, title, year, and score.
  Movie.select(:id, :title, :yr, :score).where(yr: 1980..1989).where(score: 3..5)
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  
  # bad_years = Movie.where('score > 8').pluck('yr')
  # Movie.where('yr not in (?)', bad_years).group(:yr).pluck(:yr)
  Movie.group(:yr).having('MAX(score) < 8').pluck(:yr)
end


def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Actor.joins(:movies).select(:id, :name).where('title = (?)', title).order('ord ASC')
end

def vanity_projects
  # List the title of all movies in which the director also appeared
  # as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie
  .joins(:actors).select('movies.id, movies.title, actors.name')
  .where('director_id = actor_id')
  .where('ord = 1')
  
end
# director_id of the movie is in the (cast list of the movie) && ord = 1

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.
  Actor
  .joins(:castings).select(:id, :name, 'count(*) as roles')
  .where('ord != 1')
  .group('actors.id')
  .order("roles DESC")
  .limit(2)
end
