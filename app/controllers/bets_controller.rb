class BetsController < ApplicationController
  def index
    @table = table_query
    @latest_games = latest_games
    @upcoming_games = upcoming_games
  end

  private

  def table_query
    query = <<-SQL
              WITH user_games_with_result AS (
                SELECT
                  users.name,
                  home_team_score,
                  away_team_score,
                  bets.bet,
                  CASE
                    WHEN home_team_score > away_team_score THEN '1'
                    WHEN home_team_score = away_team_score THEN 'x'
                    WHEN home_team_score < away_team_score THEN '2'
                    ELSE NULL
                  END AS result
                FROM
                  users
                JOIN
                  bets
                ON
                  bets.user_id = users.id
                JOIN
                  games
                ON
                  bets.game_id = games.id
              ), user_games_with_points AS (
                SELECT
                  *,
                  CASE
                    WHEN bet = result THEN 1
                    WHEN bet != result THEN 0
                    ELSE NULL
                  END AS points
                FROM
                  user_games_with_result
              )

              SELECT
                RANK () OVER (ORDER BY COALESCE(SUM(points), 0) DESC) AS rank,
                name,
                COUNT(*) filter (WHERE bet IS NOT NULL AND home_team_score IS NOT NULL AND away_team_score IS NOT NULL) total_bets,
                COUNT(*) filter (WHERE points = 1) AS wins,
                COUNT(*) filter (WHERE points = 0) AS losses,
                COALESCE(SUM(points), 0) AS points
              FROM
                user_games_with_points
              GROUP BY
                name
            SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def latest_games
    latest_date = Game.where.not(home_team_score: nil, away_team_score: nil).order(date: :desc).limit(1).pluck(:date)
    Game.where(date: latest_date).order(time: :asc)
  end

  def upcoming_games
    latest_date = Game.where(home_team_score: nil, away_team_score: nil).order(date: :desc).limit(1).pluck(:date)
    Game.where(date: latest_date).order(time: :asc)
  end
end
