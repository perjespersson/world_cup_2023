module BetsHelper
  def bet_opacity(bet, chosen_bet)
    return 1 if bet == chosen_bet
    0.15
  end

  def bet_background(bet, result)
    return "transparent" unless result.present?
    return "#E8FFF3" if bet == result
    "#FFF5F8"
  end
end
