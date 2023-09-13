class RemoveFullnameFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :full_name
  end
end
