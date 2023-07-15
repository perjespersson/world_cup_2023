class AddBetToBets < ActiveRecord::Migration[7.0]
  def change
    add_column :bets, :bet, :string
  end
end
