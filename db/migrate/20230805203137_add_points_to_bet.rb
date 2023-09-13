class AddPointsToBet < ActiveRecord::Migration[7.0]
  def change
    add_column :bets, :points, :integer
  end
end
