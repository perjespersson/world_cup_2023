class AddGroupToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :group, :string
  end
end
