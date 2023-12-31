class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :bet, inclusion: { in: ['1', 'x', '2'] }
end
