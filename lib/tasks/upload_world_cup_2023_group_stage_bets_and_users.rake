require 'csv'

task :upload_world_cup_2023_group_stage_bets_and_users => :environment do
  csv_file_path = Rails.root.join('lib', 'assets', 'world_cup_2023_group_stage_bets_and_users_with_teams.csv')
  bets = {}

  CSV.foreach(csv_file_path, headers: true, skip_blanks: true) do |row|
    # Find correct game
    home_team = Team.find_by(name: row['Hemmalag'])
    away_team = Team.find_by(name: row['Bortalag'])
    game = Game.find_by(home_team_id: home_team.id, away_team_id: away_team.id)

    # Skip the first two columns
    names = row.headers[2..-1]
    row_data = row.fields[2..-1]

    names.each_with_index do |name, index|
      bets[name] ||= []
      bets[name] << [row_data[index], game.id]
    end
  end

  # Create bets
  bets.each do |name, bets|
    user = User.create(name: name)
    bets.each do |bet|
      Bet.create(user_id: user.id, game_id: bet[1], bet: bet[0])
    end
  end
end
