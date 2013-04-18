task :addpoints => :environment do
  puts 'Giving 10 points to every team'
  Team.all.each do |t|
    t.points = t.points + 10
    t.save
    puts "Team #{t.team_name}: #{t.points} points"
  end
end