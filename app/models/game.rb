class Game < ApplicationRecord
  has_many :bets
  belongs_to :home_team, class_name: 'User'
  belongs_to :away_team, class_name: 'User'
end
