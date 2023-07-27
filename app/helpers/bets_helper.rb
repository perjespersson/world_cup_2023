module BetsHelper
  def bet_color(bet, answer)
    return 'transparent' unless bet["bet"] == answer # If it is not the chosen bet
    return 'rgba(0, 152 , 95, 1.0)' if bet["bet"] == bet["result"] #If bet is correct
    return 'rgba(221, 54, 54, 1.0)' if bet["bet"] != bet["result"] &&  bet["result"].present? #If bet is not correct
    return '#ebebeb' # If it is chosen and game not played yet
  end
end
