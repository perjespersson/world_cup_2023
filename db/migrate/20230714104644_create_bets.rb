class CreateBets < ActiveRecord::Migration[7.0]
  def change
    create_table :bets do |t|
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
  end
end
