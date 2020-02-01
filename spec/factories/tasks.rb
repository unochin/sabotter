FactoryBot.define do
  factory :one_time_task, class: Task do
    association :user, factory: :user
    title { 'test title' }
    tweet_content { 'test tweet content' }
    repeat_flag { :one_time }
    pause_flag { :active }
    status { :todo }
    tweet_datetime { Time.current.since(3.days) }
  end

  factory :repeat_task, class: Task do
    association :user, factory: :user
    title { 'test title' }
    tweet_content { 'test tweet content' }
    repeat_flag { :repeat }
    pause_flag { :active }
    status { :todo }
    repeat_tweet_time { Time.current }
    tweet_datetime { set_next_tweet_date(Time.current) }
    tweet_sun { 1 }
    tweet_mon { 0 }
    tweet_tue { 1 }
    tweet_wed { 0 }
    tweet_thu { 1 }
    tweet_fri { 0 }
    tweet_sat { 1 }
  end
end
