class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :bet, inclusion: { in: [1, nil, 2] }
end
