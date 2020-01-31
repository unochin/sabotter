namespace :auto_tweet do
  desc '期限が過ぎた未完了のタスクのサボったツイート'
  task auto_tweet: :environment do
    current_datetime = Time.current
    begin
      Task.active.todo.find_each do |task|
        limit_datetime = task.tweet_datetime
        if ( current_datetime.ago(1.minutes) < limit_datetime ) && ( limit_datetime < current_datetime.since(5.minutes) )
          task.auto_tweet!
        end
      end
    rescue => e
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
