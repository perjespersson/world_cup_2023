class PopulateDatabase < ActiveRecord::Migration[7.0]
  def change
    system('rake upload_teams')
    system('rake add_img_src_to_teams')
    system('rake upload_group_games')
    system('rake upload_world_cup_2023_group_stage_bets_and_users')
  end
end
