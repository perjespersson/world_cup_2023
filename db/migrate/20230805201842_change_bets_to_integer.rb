class ChangeBetsToInteger < ActiveRecord::Migration[7.0]
  def change
    # Add new column
    add_column :bets, :bet_new, :integer

    # Add bet to bet_new
    Bet.all.each do |bet|
      bet.update(bet_new: bet.bet)
    end

    # Remove column
    remove_column :bets, :bet

    # Rename column
    rename_column :bets, :bet_new, :bet
  end
end
