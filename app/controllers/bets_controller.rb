class BetsController < ApplicationController
  def index
    @table = table_query
    @games_by_date = games_by_date
    @latest_games = latest_games
  end

  private

  def table_query
    query = <<-SQL
              WITH user_games_with_result AS (
                SELECT
                  users.name,
                  bets.bet,
                    CASE
                  WHEN home_team_score > away_team_score THEN '1'
                  WHEN home_team_score = away_team_score THEN 'x'
                  ELSE '2'
                END AS result
                FROM
                  users
                JOIN
                  bets
                ON
                  bets.user_id = users.id
                  AND bets.bet IS NOT NULL
                JOIN
                  games
                ON
                  bets.game_id = games.id
                  AND games.home_team_score IS NOT NULL
                  AND games.away_team_score IS NOT NULL
              ), user_games_with_points AS (
                SELECT
                  *,
                  CASE
                    WHEN bet = result THEN 1
                    ELSE 0
                  END AS points
                FROM
                  user_games_with_result
              )

              SELECT
                RANK () OVER (ORDER BY SUM(points) DESC) AS rank,
                name,
                COUNT(*) AS total_bets,
                COUNT(*) filter (WHERE points = 1) AS wins,
                COUNT(*) filter (WHERE points = 0) AS losses,
                SUM(points) AS points
              FROM
                user_games_with_points
              GROUP BY
                name
            SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def games_by_date
    Game.joins('JOIN teams AS home_teams ON home_teams.id = games.home_team_id')
                         .joins('JOIN teams AS away_teams ON away_teams.id = games.away_team_id')
                         .select("date, ARRAY_AGG(ARRAY[home_team_score::text, away_team_score::text, home_teams.name::text, away_teams.name::text, time::text]) AS games")
                         .group(:date)
                         .order(date: :asc)
  end

  def latest_games
    latest_date = Game.where.not(home_team_score: nil, away_team_score: nil).order(date: :desc).limit(1).pluck(:date)
    Game.where(date: latest_date)
  end
end
