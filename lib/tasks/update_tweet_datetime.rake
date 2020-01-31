namespace :update_tweet_datetime do
  desc '期限が過ぎている繰り返しタスクのtweet_datetimeカラムをupdate'
  task update_tweet_datetime: :environment do
    current_datetime = Time.current
    begin
      Task.repeat.find_each do |task|
        if task.tweet_datetime < current_datetime
          task.set_next_tweet_date(current_datetime)
          task.todo!
        end
      end
    rescue StandardError => e
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
