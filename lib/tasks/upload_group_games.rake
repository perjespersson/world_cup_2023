task :upload_group_games => :environment do
  games_data = [
    { time: '09:00', home_team: 'Nya Zeeland', away_team: 'Norge', date: '2023-07-20', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Australien', away_team: 'Irland', date: '2023-07-20', game_type: 'group_stage' },
    { time: '04:30', home_team: 'Nigeria', away_team: 'Kanada', date: '2023-07-21', game_type: 'group_stage' },
    { time: '07:00', home_team: 'Filippinerna', away_team: 'Schweiz', date: '2023-07-21', game_type: 'group_stage' },
    { time: '09:30', home_team: 'Spanien', away_team: 'Costa Rica', date: '2023-07-21', game_type: 'group_stage' },
    { time: '03:00', home_team: 'USA', away_team: 'Vietnam', date: '2023-07-22', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Zambia', away_team: 'Japan', date: '2023-07-22', game_type: 'group_stage' },
    { time: '11:30', home_team: 'England', away_team: 'Haiti', date: '2023-07-22', game_type: 'group_stage' },
    { time: '14:00', home_team: 'Danmark', away_team: 'Kina', date: '2023-07-22', game_type: 'group_stage' },
    { time: '07:00', home_team: 'Sverige', away_team: 'Sydafrika', date: '2023-07-23', game_type: 'group_stage' },
    { time: '09:30', home_team: 'Nederländerna', away_team: 'Portugal', date: '2023-07-23', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Frankrike', away_team: 'Jamaica', date: '2023-07-23', game_type: 'group_stage' },
    { time: '08:00', home_team: 'Italien', away_team: 'Argentina', date: '2023-07-24', game_type: 'group_stage' },
    { time: '10:30', home_team: 'Tyskland', away_team: 'Marocko', date: '2023-07-24', game_type: 'group_stage' },
    { time: '13:00', home_team: 'Brasilien', away_team: 'Panama', date: '2023-07-24', game_type: 'group_stage' },
    { time: '04:00', home_team: 'Colombia', away_team: 'Sydkorea', date: '2023-07-25', game_type: 'group_stage' },
    { time: '07:30', home_team: 'Nya Zeeland', away_team: 'Filippinerna', date: '2023-07-25', game_type: 'group_stage' },
    { time: '10:00', home_team: 'Schweiz', away_team: 'Norge', date: '2023-07-25', game_type: 'group_stage' },
    { time: '07:00', home_team: 'Japan', away_team: 'Costa Rica', date: '2023-07-26', game_type: 'group_stage' },
    { time: '09:30', home_team: 'Spanien', away_team: 'Zambia', date: '2023-07-26', game_type: 'group_stage' },
    { time: '14:00', home_team: 'Kanada', away_team: 'Irland', date: '2023-07-26', game_type: 'group_stage' },
    { time: '03:00', home_team: 'USA', away_team: 'Nederländerna', date: '2023-07-27', game_type: 'group_stage' },
    { time: '09:30', home_team: 'Portugal', away_team: 'Vietnam', date: '2023-07-27', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Australien', away_team: 'Nigeria', date: '2023-07-27', game_type: 'group_stage' },
    { time: '02:00', home_team: 'Argentina', away_team: 'Sydafrika', date: '2023-07-28', game_type: 'group_stage' },
    { time: '10:30', home_team: 'England', away_team: 'Danmark', date: '2023-07-28', game_type: 'group_stage' },
    { time: '13:00', home_team: 'Kina', away_team: 'Haiti', date: '2023-07-28', game_type: 'group_stage' },
    { time: '09:30', home_team: 'Sverige', away_team: 'Italien', date: '2023-07-29', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Frankrike', away_team: 'Brasilien', date: '2023-07-29', game_type: 'group_stage' },
    { time: '14:30', home_team: 'Panama', away_team: 'Jamaica', date: '2023-07-29', game_type: 'group_stage' },
    { time: '06:30', home_team: 'Sydkorea', away_team: 'Marocko', date: '2023-07-30', game_type: 'group_stage' },
    { time: '11:30', home_team: 'Tyskland', away_team: 'Colombia', date: '2023-07-30', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Schweiz', away_team: 'Nya Zeeland', date: '2023-07-30', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Norge', away_team: 'Filippinerna', date: '2023-07-30', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Japan', away_team: 'Spanien', date: '2023-07-31', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Costa Rica', away_team: 'Zambia', date: '2023-07-31', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Kanada', away_team: 'Australien', date: '2023-07-31', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Irland', away_team: 'Nigeria', date: '2023-07-31', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Portugal', away_team: 'USA', date: '2023-08-01', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Vietnam', away_team: 'Nederländerna', date: '2023-08-01', game_type: 'group_stage' },
    { time: '13:00', home_team: 'Kina', away_team: 'England', date: '2023-08-01', game_type: 'group_stage' },
    { time: '13:00', home_team: 'Haiti', away_team: 'Danmark', date: '2023-08-01', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Argentina', away_team: 'Sverige', date: '2023-08-02', game_type: 'group_stage' },
    { time: '09:00', home_team: 'Sydafrika', away_team: 'Italien', date: '2023-08-02', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Panama', away_team: 'Frankrike', date: '2023-08-02', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Jamaica', away_team: 'Brasilien', date: '2023-08-02', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Sydkorea', away_team: 'Tyskland', date: '2023-08-03', game_type: 'group_stage' },
    { time: '12:00', home_team: 'Marocko', away_team: 'Colombia', date: '2023-08-03', game_type: 'group_stage' }
  ]

  games_data.each do |game_data|
    home_team = Team.find_by(name: game_data[:home_team])
    away_team = Team.find_by(name: game_data[:away_team])

    Game.create(
      time: game_data[:time],
      home_team_id: home_team.id,
      away_team_id: away_team.id,
      date: game_data[:date],
      game_type: game_data[:game_type]
    )
  end
end
