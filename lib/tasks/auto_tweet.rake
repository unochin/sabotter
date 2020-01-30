namespace :auto_tweet do
  desc '期限が過ぎた未完了のタスクのサボったツイート'
  task auto_tweet: :environment do
    current_datetime = Time.current.strftime("%Y-%m-%d %H:%M:00")
    begin
      Task.active.todo.find_each do |task|
        limit_datetime = task.tweet_datetime.strftime("%Y-%m-%d %H:%M:00")
        if current_datetime == limit_datetime
          task.auto_tweet
        end
      end
    rescue => e
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
