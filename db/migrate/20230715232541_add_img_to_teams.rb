class AddImgToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :img, :string
  end
end
