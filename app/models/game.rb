class Game < ApplicationRecord
  has_many :bets

  def home_team
    Team.find(self.home_team_id)
  end

  def away_team
    Team.find(self.away_team_id)
  end

  validates :home_team_score, presence: true, on: :update
  validates :away_team_score, presence: true, on: :update
end
