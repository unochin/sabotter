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

# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env

# 30分毎に自動ツイート
every 1.day, at: ['0:00 am', '0:30 am', '1:00 am', '1:30 am',
                  '2:00 am', '2:30 am', '3:00 am', '3:30 am',
                  '4:00 am', '4:30 am', '5:00 am', '5:30 am',
                  '6:00 am', '6:30 am', '7:00 am', '7:30 am',
                  '8:00 am', '8:30 am', '9:00 am', '9:30 am',
                  '10:00 am', '10:30 am', '11:00 am', '11:30 am',
                  '0:00 pm', '0:30 pm', '1:00 pm', '1:30 pm',
                  '2:00 pm', '2:30 pm', '3:00 pm', '3:30 pm',
                  '4:00 pm', '4:30 pm', '5:00 pm', '5:30 pm',
                  '6:00 pm', '6:30 pm', '7:00 pm', '7:30 pm',
                  '8:00 pm', '8:30 pm', '9:00 pm', '9:30 pm',
                  '10:00 pm', '10:30 pm', '11:00 pm', '11:30 pm'
                ] do
  rake 'auto_tweet:auto_tweet'
end

# 毎日1回繰り返しツイートの期限を更新
every :day, at: '0:15am' do
  rake 'update_tweet_datetime:update_tweet_datetime'
end
