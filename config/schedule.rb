# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every '0,15,30,45 11-20 20 4 *' do
  rake "addpoints"
end

every '0,10,20,30,40,50 * 19-20 4 *' do
  command "d=$(date +%F-%H-%M);fn=\"$d.sqlite3.bak\";cp db/production.sqlite3 dbback/$fn"
end