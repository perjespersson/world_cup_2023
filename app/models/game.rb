class Game < ApplicationRecord
  has_many :bets

  def home_team
    Team.find(self.home_team_id).name
  end

  def away_team
    Team.find(self.away_team_id).name
  end
end
