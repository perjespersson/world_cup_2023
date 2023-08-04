class GamesController < ApplicationController
  def index
    @games_by_date = games_by_date(params[:filter])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])

    if @game.update(home_team_score: params[:game][:home_team_score], away_team_score: params[:game][:away_team_score])
      redirect_to edit_game_path(params[:id]), notice: "Resultat uppdaterat!"
    else
      redirect_to edit_game_path(params[:id]), alert: "Någonting gick fel, testa igen!"
    end
  end

  private

  def games_by_date(filter)
    # TODO: Order by time aswell
    Game.joins('JOIN teams AS home_teams ON home_teams.id = games.home_team_id')
        .joins('JOIN teams AS away_teams ON away_teams.id = games.away_team_id')
        .select("date, ARRAY_AGG(ARRAY[home_team_score::text, away_team_score::text, home_teams.name::text, away_teams.name::text, time::text, home_teams.img::text, away_teams.img::text, games.id::text]) AS games")
        .where(filter_clause(filter))
        .group(:date)
        .order(date: :asc)
  end

  def filter_clause(filter)
    return "home_team_score IS NULL AND away_team_score IS NULL" if filter == "future"
    return "home_team_score IS NOT NULL AND away_team_score IS NOT NULL" if filter == "past"
    ""
  end
end
