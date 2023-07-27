class BetsController < ApplicationController
  def index
    @table = table_query
    @current_games = current_games
    @previous_games = previous_games
    @upcoming_games = upcoming_games
  end

  def user_bets
    @user_bets = user_bets_query(params[:id])

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def user_bets_query(user_id)
    query = <<-SQL
              WITH user_games_with_bets AS (
                SELECT
                  users.name,
                  bets.bet,
                  home_team.name as home_team,
                  away_team.name as away_team,
                  home_team_score,
                  away_team_score
                FROM
                  users
                JOIN
                  bets
                ON
                  bets.user_id = users.id
                JOIN
                  games
                ON
                  games.id = bets.game_id
                JOIN
                  teams home_team
                ON
                  home_team.id = games.home_team_id
                JOIN
                  teams away_team
                ON
                  away_team.id = games.away_team_id
                WHERE
                  users.id = #{user_id}
              )

              SELECT
                *,
                CASE
                  WHEN home_team_score > away_team_score THEN '1'
                  WHEN home_team_score = away_team_score THEN 'x'
                  WHEN home_team_score < away_team_score THEN '2'
                END AS result
              FROM
                user_games_with_bets
            SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def table_query
    query = <<-SQL
              WITH user_games_with_result AS (
                SELECT
                  users.name,
                  users.id AS user_id,
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
              ), user_games_with_statistics AS (
                SELECT
                  RANK () OVER (ORDER BY COALESCE(SUM(points), 0) DESC) AS rank,
                  name,
                  user_id,
                  COUNT(*) filter (WHERE bet IS NOT NULL AND home_team_score IS NOT NULL AND away_team_score IS NOT NULL) total_bets,
                  COUNT(*) filter (WHERE points = 1) AS wins,
                  COUNT(*) filter (WHERE points = 0) AS losses,
                  COALESCE(SUM(points), 0) AS points
                FROM
                  user_games_with_points
                GROUP BY
                  name,
                  user_id
              )

              SELECT
                *,
                COALESCE(((wins::float / NULLIF(total_bets::float, 0)) * 100)::integer, 0) AS hit_rate /* If it is 0 -> NULL which results in the whole becoming NULL. Therefore coalesce to set it to 0 */
              FROM
                user_games_with_statistics
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
