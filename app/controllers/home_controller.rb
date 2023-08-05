class HomeController < ApplicationController
  def index
    @table = table_query
    @current_games = current_games
    @previous_games = previous_games
    @upcoming_games = upcoming_games
  end

  private

  def table_query
    query = <<-SQL
              WITH games_with_winners AS (
                SELECT
                  id,
                  CASE
                    WHEN home_team_score > away_team_score THEN home_team_id
                    WHEN home_team_score < away_team_score THEN away_team_id
                    ELSE NULL
                  END AS winner
                FROM
                  games
                WHERE
                  games.home_team_score IS NOT NULL
                  AND games.away_team_score IS NOT NULL
              ), games_with_winners_and_statistics AS (
                SELECT
                  games_with_winners.id,
                  games_with_winners.winner,
                  COUNT(*) total_bets,
                  COUNT(*) FILTER(WHERE games_with_winners.winner = bets.bet::integer) AS total_corrects
                FROM
                  games_with_winners
                JOIN
                  bets
                ON
                  bets.game_id = games_with_winners.id
                GROUP BY
                  games_with_winners.id,
                  games_with_winners.winner
              ), games_with_winners_and_points AS (
                SELECT
                  id,
                  winner,
                  ((1 - (total_corrects::float / total_bets::float)) * 10)::integer AS points
                FROM
                  games_with_winners_and_statistics
              ), games_with_normalised_points AS (
                SELECT
                  id,
                  winner,
                  CASE
                    WHEN points = 0 THEN 1
                    ELSE points
                  END AS POINTS
                FROM
                  games_with_winners_and_points
              ), users_with_points AS (
                SELECT
                  users.name,
                  users.id AS user_id,
                  CASE
                    WHEN winner = bet::integer OR (winner IS NULL AND bet IS NULL) THEN points
                    ELSE 0
                  END AS points
                FROM
                  games_with_normalised_points
                JOIN
                  bets
                ON
                  bets.game_id = games_with_normalised_points.id
                JOIN
                  users
                ON
                bets.user_id = users.id
              ), user_with_points_and_statistics AS (
                SELECT
                  RANK () OVER (ORDER BY COALESCE(SUM(points), 0) DESC) AS rank,
                  name,
                  user_id,
                  COUNT(*) AS total_bets,
                  COUNT(*) filter (WHERE points > 0) AS wins,
                  COUNT(*) filter (WHERE points = 0) AS losses,
                  COALESCE(SUM(points), 0) AS points
                FROM
                  users_with_points
                GROUP BY
                  name,
                  user_id
              )

              SELECT
                *,
                COALESCE(((wins::float / NULLIF(total_bets::float, 0)) * 100)::integer, 0) AS hit_rate /* If it is 0 -> NULL which results in the whole becoming NULL. Therefore coalesce to set it to 0 */
              FROM
                user_with_points_and_statistics
            SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def current_date
    @current_date ||= Game.where(home_team_score: nil, away_team_score: nil).order(date: :asc).limit(1).pluck(:date)
  end

  def previous_date
    @previous_date ||= Game.where("date < ?", current_date)
                       .order(date: :desc)
                       .limit(1)
                       .pluck(:date)
  end

  def next_date
    @next_date ||= Game.where("date > ?", current_date)
                       .order(date: :asc)
                       .limit(1)
                       .pluck(:date)
  end

  def current_games
    Game.where(date: current_date).order(time: :asc)
  end

  def previous_games
    Game.where(date: previous_date).order(time: :asc)
  end

  def upcoming_games
    Game.where(date: next_date).order(time: :asc)
  end
end
