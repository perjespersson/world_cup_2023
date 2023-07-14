class Team < ApplicationRecord
  def games
    Game.where("home_team_id = ? OR away_team_id = ?", self.id, self.id)
  end
end
