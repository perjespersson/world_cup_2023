task :upload_group_games => :environment do
  games_data = [
    { time: '09:00', home_team: 'Nya Zeeland', away_team: 'Norge', date: '2023-07-20' },
    { time: '12:00', home_team: 'Australien', away_team: 'Irland', date: '2023-07-20' },
    { time: '04:30', home_team: 'Nigeria', away_team: 'Kanada', date: '2023-07-21' },
    { time: '07:00', home_team: 'Filippinerna', away_team: 'Schweiz', date: '2023-07-21' },
    { time: '09:30', home_team: 'Spanien', away_team: 'Costa Rica', date: '2023-07-21' },
    { time: '03:00', home_team: 'USA', away_team: 'Vietnam', date: '2023-07-22' },
    { time: '09:00', home_team: 'Zambia', away_team: 'Japan', date: '2023-07-22' },
    { time: '11:30', home_team: 'England', away_team: 'Haiti', date: '2023-07-22' },
    { time: '14:00', home_team: 'Danmark', away_team: 'Kina', date: '2023-07-22' },
    { time: '07:00', home_team: 'Sverige', away_team: 'Sydafrika', date: '2023-07-23' },
    { time: '09:30', home_team: 'Nederländerna', away_team: 'Portugal', date: '2023-07-23' },
    { time: '12:00', home_team: 'Frankrike', away_team: 'Jamaica', date: '2023-07-23' },
    { time: '08:00', home_team: 'Italien', away_team: 'Argentina', date: '2023-07-24' },
    { time: '10:30', home_team: 'Tyskland', away_team: 'Marocko', date: '2023-07-24' },
    { time: '13:00', home_team: 'Brasilien', away_team: 'Panama', date: '2023-07-24' },
    { time: '04:00', home_team: 'Colombia', away_team: 'Sydkorea', date: '2023-07-25' },
    { time: '07:30', home_team: 'Nya Zeeland', away_team: 'Filippinerna', date: '2023-07-25' },
    { time: '10:00', home_team: 'Schweiz', away_team: 'Norge', date: '2023-07-25' },
    { time: '07:00', home_team: 'Japan', away_team: 'Costa Rica', date: '2023-07-26' },
    { time: '09:30', home_team: 'Spanien', away_team: 'Zambia', date: '2023-07-26' },
    { time: '14:00', home_team: 'Kanada', away_team: 'Irland', date: '2023-07-26' },
    { time: '03:00', home_team: 'USA', away_team: 'Nederländerna', date: '2023-07-27' },
    { time: '09:30', home_team: 'Portugal', away_team: 'Vietnam', date: '2023-07-27' },
    { time: '12:00', home_team: 'Australien', away_team: 'Nigeria', date: '2023-07-27' },
    { time: '02:00', home_team: 'Argentina', away_team: 'Sydafrika', date: '2023-07-28' },
    { time: '10:30', home_team: 'England', away_team: 'Danmark', date: '2023-07-28' },
    { time: '13:00', home_team: 'Kina', away_team: 'Haiti', date: '2023-07-28' },
    { time: '09:30', home_team: 'Sverige', away_team: 'Italien', date: '2023-07-29' },
    { time: '12:00', home_team: 'Frankrike', away_team: 'Brasilien', date: '2023-07-29' },
    { time: '14:30', home_team: 'Panama', away_team: 'Jamaica', date: '2023-07-29' },
    { time: '06:30', home_team: 'Sydkorea', away_team: 'Marocko', date: '2023-07-30' },
    { time: '11:30', home_team: 'Tyskland', away_team: 'Colombia', date: '2023-07-30' },
    { time: '09:00', home_team: 'Schweiz', away_team: 'Nya Zeeland', date: '2023-07-30' },
    { time: '09:00', home_team: 'Norge', away_team: 'Filippinerna', date: '2023-07-30' },
    { time: '09:00', home_team: 'Japan', away_team: 'Spanien', date: '2023-07-31' },
    { time: '09:00', home_team: 'Costa Rica', away_team: 'Zambia', date: '2023-07-31' },
    { time: '12:00', home_team: 'Kanada', away_team: 'Australien', date: '2023-07-31' },
    { time: '12:00', home_team: 'Irland', away_team: 'Nigeria', date: '2023-07-31' },
    { time: '09:00', home_team: 'Portugal', away_team: 'USA', date: '2023-08-01' },
    { time: '09:00', home_team: 'Vietnam', away_team: 'Nederländerna', date: '2023-08-01' },
    { time: '13:00', home_team: 'Kina', away_team: 'England', date: '2023-08-01' },
    { time: '13:00', home_team: 'Haiti', away_team: 'Danmark', date: '2023-08-01' },
    { time: '09:00', home_team: 'Argentina', away_team: 'Sverige', date: '2023-08-02' },
    { time: '09:00', home_team: 'Sydafrika', away_team: 'Italien', date: '2023-08-02' },
    { time: '12:00', home_team: 'Panama', away_team: 'Frankrike', date: '2023-08-02' },
    { time: '12:00', home_team: 'Jamaica', away_team: 'Brasilien', date: '2023-08-02' },
    { time: '12:00', home_team: 'Sydkorea', away_team: 'Tyskland', date: '2023-08-03' },
    { time: '12:00', home_team: 'Marocko', away_team: 'Colombia', date: '2023-08-03' }
  ]

  games_data.each do |game_data|
    home_team = Team.find_by(name: game_data[:home_team])
    home_team_id = home_team ? home_team.id : nil

    away_team = Team.find_by(name: game_data[:away_team])
    away_team_id = away_team ? away_team.id : nil

    Game.create!(
      time: game_data[:time],
      home_team_id: home_team_id,
      away_team_id: away_team_id,
      date: game_data[:date]
    )
  end
end
