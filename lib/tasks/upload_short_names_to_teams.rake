task :upload_short_names_to_teams => :environment do
  teams_data = [
    {team: "Nya Zeeland", short_name: "NZL"},
    {team: "Norge", short_name: "NOR"},
    {team: "Filippinerna", short_name: "PHL"},
    {team: "Schweiz", short_name: "CHE"},
    {team: "Australien", short_name: "AUS"},
    {team: "Irland", short_name: "IRL"},
    {team: "Nigeria", short_name: "NGA"},
    {team: "Kanada", short_name: "CAN"},
    {team: "Spanien", short_name: "ESP"},
    {team: "Costa Rica", short_name: "CRI"},
    {team: "Zambia", short_name: "ZMB"},
    {team: "Japan", short_name: "JPN"},
    {team: "England", short_name: "ENG"},
    {team: "Danmark", short_name: "DNK"},
    {team: "Kina", short_name: "CHN"},
    {team: "Haiti", short_name: "HTI"},
    {team: "USA", short_name: "USA"},
    {team: "Vietnam", short_name: "VNM"},
    {team: "Nederländerna", short_name: "NLD"},
    {team: "Portugal", short_name: "PRT"},
    {team: "Frankrike", short_name: "FRA"},
    {team: "Jamaica", short_name: "JAM"},
    {team: "Brasilien", short_name: "BRA"},
    {team: "Panama", short_name: "PAN"},
    {team: "Sverige", short_name: "SWE"},
    {team: "Sydafrika", short_name: "ZAF"},
    {team: "Italien", short_name: "ITA"},
    {team: "Argentina", short_name: "ARG"},
    {team: "Tyskland", short_name: "DEU"},
    {team: "Marocko", short_name: "MAR"},
    {team: "Colombia", short_name: "COL"},
    {team: "Sydkorea", short_name: "KOR"}
  ]


  teams_data.each do |team_data|
    team = Team.find_by(name: team_data[:team])
    team.update(short_name: team_data[:short_name])
  end
end
