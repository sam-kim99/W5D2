# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery';
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
  SELECT
    m.title
  FROM
    castings as c
    JOIN
      movies as m on m.id = c.movie_id
      JOIN
      actors as a on a.id = c.actor_id
  WHERE
    a.name = 'Harrison Ford';
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the starring
  # role. [Note: The ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role.]
  execute(<<-SQL)
  SELECT
    m.title
  FROM
    castings as c
    JOIN
      movies as m on m.id = c.movie_id
      JOIN
      actors as a on a.id = c.actor_id
  WHERE
    a.name = 'Harrison Ford' AND c.ord != 1;
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
  SELECT
    m.title, a.name
  FROM
    castings as c
    JOIN
      movies as m on m.id = c.movie_id
      JOIN
      actors as a on a.id = c.actor_id
  WHERE
    m.yr=1962 AND c.ord = 1;
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
  SELECT m.yr, COUNT(m.id)

  FROM
    castings as c
    JOIN
      movies as m on m.id = c.movie_id
      JOIN
      actors as a on a.id = c.actor_id
  WHERE
  a.name = 'John Travolta'
  GROUP BY m.yr
  HAVING COUNT(m.id) >= 2;


  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie
  # Andrews' played in.
  execute(<<-SQL)
  SELECT m_with_lead.title, m_with_lead.leading
  FROM
    castings as c
    JOIN
      (SELECT
      m1.id, m1.title, a1.name as leading
      FROM
      castings as c1
      JOIN
        movies as m1 on m1.id = c1.movie_id
        JOIN
        actors as a1 on a1.id = c1.actor_id
      WHERE
        c1.ord = 1) as m_with_lead on m_with_lead.id = c.movie_id
      JOIN
      actors as a on a.id = c.actor_id
  WHERE
    a.name = 'Julie Andrews';
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL)
  SELECT a.name
  FROM
  castings as c
    JOIN
    actors as a on c.actor_id = a.id
  WHERE
  c.ord = 1
  GROUP BY a.name
  HAVING COUNT(c.movie_id) >=15
  ORDER BY a.name;

  SQL
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
  SELECT m.title, COUNT(c.actor_id) as num_actors
  FROM
  movies as m
    JOIN
    castings as c on m.id = c.movie_id
  WHERE
  m.yr = 1978
  GROUP BY m.title
  ORDER BY COUNT(c.actor_id) DESC, m.title;
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL)
  SELECT DISTINCT a.name
  FROM
  castings as c JOIN (SELECT c.movie_id as id
  FROM
  castings as c JOIN actors as a on c.actor_id = a.id
  WHERE a.name = 'Art Garfunkel') as ar_moive on c.movie_id = ar_moive.id
    JOIN actors as a on c.actor_id = a.id
  WHERE
  a.name != 'Art Garfunkel';


  SQL
end
