class BetsController < ApplicationController
  def index
    @user_bets = user_bets_query(params[:user_id], params[:filter])
  end

  private

  def user_bets_query(user_id, filter)
    query = <<-SQL
              WITH user_games_with_bets AS (
                SELECT
                  users.name,
                  bets.bet,
                  home_team.short_name as home_team,
                  home_team.img as home_team_img,
                  away_team.short_name as away_team,
                  away_team.img as away_team_img,
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
              #{user_bets_filter_clause(filter)}
            SQL

    ActiveRecord::Base.connection.execute(query)
  end

  private

  def user_bets_filter_clause(filter)
    return "WHERE home_team_score IS NULL AND away_team_score IS NULL" if filter == "future"
    return "WHERE home_team_score IS NOT NULL AND away_team_score IS NOT NULL" if filter == "past"
    ""
  end
end
