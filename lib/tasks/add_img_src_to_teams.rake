task add_img_src_to_teams: :environment do
  Team.all.each do |team|
    team.update(img: I18n.transliterate(team.name).parameterize(separator: "-") + ".png")
  end
end
