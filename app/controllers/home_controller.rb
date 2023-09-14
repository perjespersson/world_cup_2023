class HomeController < ApplicationController
  def index
    @table = table_query
    @current_games = current_games
    @previous_games = previous_games
    @upcoming_games = upcoming_games
  end

  private

  # You get points depending what the other bet
  # The more that bets on it, the less points
  # Example 1: 1 of 10 bets on home_win then
  # (1 - (1/10)) * 10) = 9 points
  # Example 2: All bets on home_win then
  # (1 - (10/10)) * 10) = 0 -> (NORMALISING) = 1 point
  # You have to guess correct to get points
  def table_query
    query = <<-SQL
    WITH games_with_correct_bet AS (
      SELECT
        games.id,
        date,
        time,
        home_teams.short_name as home_team_name,
        away_teams.short_name as away_team_name,
        CASE
          WHEN home_team_score > away_team_score THEN home_team_id
          WHEN home_team_score < away_team_score THEN away_team_id
          ELSE NULL
        END AS winner
      FROM
        games
      JOIN
        teams AS home_teams
      ON
        home_teams.id = games.home_team_id
      JOIN
        teams AS away_teams
      ON
        away_teams.id = games.away_team_id
      WHERE
        games.home_team_score IS NOT NULL
        AND games.away_team_score IS NOT NULL
    ), games_with_correct_bet_and_statistics AS (
      SELECT
        games_with_correct_bet.id,
        games_with_correct_bet.date,
        games_with_correct_bet.time,
        games_with_correct_bet.winner,
        home_team_name,
        away_team_name,
        COUNT(*) total_bets,
        COUNT(*) FILTER(
                        WHERE
                          games_with_correct_bet.winner = bets.bet
                          OR (games_with_correct_bet.winner IS NULL AND bets.bet IS NULL)
                        )
        AS total_corrects
      FROM
        games_with_correct_bet
      JOIN
        bets
      ON
        bets.game_id = games_with_correct_bet.id
      GROUP BY
        games_with_correct_bet.id,
        games_with_correct_bet.date,
        games_with_correct_bet.time,
        games_with_correct_bet.winner,
        home_team_name,
        away_team_name
    ), games_with_correct_bet_and_points AS (
      SELECT
        id,
        date,
        home_team_name,
        away_team_name,
        time,
        winner,
        ((1 - (total_corrects::float / total_bets::float)) * 10)::integer AS points
      FROM
        games_with_correct_bet_and_statistics
    ), games_with_normalised_points AS (
      SELECT
        id,
        date,
        home_team_name,
        away_team_name,
        time,
        winner,
        CASE
          WHEN points = 0 THEN 1
          ELSE points
        END AS points
      FROM
        games_with_correct_bet_and_points
    ), users_with_games_and_points AS (
      SELECT
        games_with_normalised_points.id AS game_id,
        games_with_normalised_points.date AS game_date,
        games_with_normalised_points.time AS game_time,
        home_team_name,
        away_team_name,
        users.name,
        users.id AS user_id,
        CASE
          WHEN winner = bet OR (winner IS NULL AND bet IS NULL) THEN games_with_normalised_points.points
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
    ), user_last_5_points AS (
SELECT
    user_id,
    JSONB_AGG(JSON_BUILD_OBJECT('points', points, 'home_team_name', home_team_name, 'away_team_name', away_team_name)) AS recent_points
FROM (
    SELECT
        user_id,
        points,
        game_date,
        game_time,
        home_team_name,
            away_team_name,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY game_date DESC, game_time DESC, game_id DESC) AS rank
    FROM
        users_with_games_and_points
) AS ranked_data
WHERE
  rank <= 5
GROUP BY
    user_id
), user_with_points_and_statistics AS (
      SELECT
        RANK () OVER (ORDER BY COALESCE(SUM(points), 0) DESC) AS rank,
        name,
        users_with_games_and_points.user_id,
        COUNT(*) AS total_bets,
        COUNT(*) filter (WHERE points > 0) AS wins,
        COUNT(*) filter (WHERE points = 0) AS losses,
        COALESCE(SUM(points), 0) AS points,
        user_last_5_points.recent_points
      FROM
        users_with_games_and_points
      LEFT JOIN
        user_last_5_points
      ON
        user_last_5_points.user_id = users_with_games_and_points.user_id
      GROUP BY
        users_with_games_and_points.name,
        users_with_games_and_points.user_id,
        user_last_5_points.recent_points
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
