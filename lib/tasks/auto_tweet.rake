namespace :auto_tweet do
  desc '期限が過ぎた未完了のタスクのサボったツイート'
  task auto_tweet: :environment do
    begin
      Task.have_to_tweet.find_each do |task|
        task.auto_tweet!
      end
    rescue => e
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
