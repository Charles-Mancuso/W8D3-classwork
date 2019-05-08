def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  
  
  # Movie
  # .joins(:actors)
  # .select(:title, :id)
  # .where('actors.name IN (?)', those_actors)
  # .group(:title, :id)
  
  Movie
    .select(:title, :id)
    .joins(:actors)
    .where(actors: { name: those_actors })
    .group(:id)
    .having('COUNT(actors.id) >= ?', those_actors.length)
end

def golden_age
  # Find the decade with the highest average movie score.
  Movie.select('AVG(score), (yr / 10) * 10 as decade')
  .group('decade')
  .order('AVG(score) desc')
  .first
  .decade

end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  var = Movie.joins(:actors).where('actors.name = (?)', name).pluck('id')
  Movie.joins(:actors).where('movies.id IN (?)', var).where.not('actors.name = (?)', name).distinct.pluck('name')
end


def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor.left_outer_joins(:castings).where('castings.actor_id is null').count
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"


  # NOT OUR SOLUTION VVVVVVVVVV
  matcher = "%#{whazzername.split("").join('%')}%"
  Movie.joins(:actors).where('UPPER(actors.name) LIKE UPPER(?)', matcher)
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Movie.select('actors.id', 'actors.name', 'MAX(yr) - MIN(yr) as career').joins(:actors)
  .group('actors.id')
  .order('career desc')
  .limit(3)
end
