task :addpoints => :environment do
  Team.all.each do |t|
    t.points = t.points + 10
    t.save
  end
end

task :resetallpoints => :environment do
  Team.all.each do |t|
    t.points = 0
    t.save
  end
end