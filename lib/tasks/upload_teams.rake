task upload_teams: :environment do
  teams = [
    { name: 'Nya Zeeland', group: 'A' },
    { name: 'Norge', group: 'A' },
    { name: 'Filippinerna', group: 'A' },
    { name: 'Schweiz', group: 'A' },
    { name: 'Australien', group: 'B' },
    { name: 'Irland', group: 'B' },
    { name: 'Nigeria', group: 'B' },
    { name: 'Kanada', group: 'B' },
    { name: 'Spanien', group: 'C' },
    { name: 'Costa Rica', group: 'C' },
    { name: 'Zambia', group: 'C' },
    { name: 'Japan', group: 'C' },
    { name: 'England', group: 'D' },
    { name: 'Danmark', group: 'D' },
    { name: 'Kina', group: 'D' },
    { name: 'Haiti', group: 'D' },
    { name: 'USA', group: 'E' },
    { name: 'Vietnam', group: 'E' },
    { name: 'Nederländerna', group: 'E' },
    { name: 'Portugal', group: 'E' },
    { name: 'Frankrike', group: 'F' },
    { name: 'Jamaica', group: 'F' },
    { name: 'Brasilien', group: 'F' },
    { name: 'Panama', group: 'F' },
    { name: 'Sverige', group: 'G' },
    { name: 'Sydafrika', group: 'G' },
    { name: 'Italien', group: 'G' },
    { name: 'Argentina', group: 'G' },
    { name: 'Tyskland', group: 'H' },
    { name: 'Marocko', group: 'H' },
    { name: 'Colombia', group: 'H' },
    { name: 'Sydkorea', group: 'H' }
  ]

  teams.each do |team|
    Team.create(name: team[:name], group: team[:group])
  end
end
