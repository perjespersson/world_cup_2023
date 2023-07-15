class BetsController < ApplicationController
  def index
    @bets = Bet.all
  end
end
