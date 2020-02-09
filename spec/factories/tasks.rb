FactoryBot.define do
  factory :task do
    association :user
    title { 'test title' }
    tweet_content { 'test tweet content' }
    pause_flag { :active }
    status { :todo }

    trait :one_time_task do
      repeat_flag { :one_time }
      tweet_datetime { "#{Time.current.year}-#{Time.current.month}-#{Time.current.day + 1} #{Time.current.hour}:30:00".in_time_zone }
    end
    trait :repeat_task do
      repeat_flag { :repeat }
      repeat_tweet_time { "#{Time.current.hour}:30:00".in_time_zone }
      tweet_datetime { set_next_tweet_date("#{Time.current.year}-#{Time.current.month}-#{Time.current.day + 1} #{Time.current.hour}:30:00".in_time_zone) }
      tweet_sun { 1 }
      tweet_mon { 0 }
      tweet_tue { 1 }
      tweet_wed { 0 }
      tweet_thu { 1 }
      tweet_fri { 0 }
      tweet_sat { 1 }
    end
  end

  factory :task_for_rake, class: Task do
    association :user
    title { 'test title' }
    tweet_content { 'test tweet content' }

    trait :one_time do
      repeat_flag { :one_time }
    end
    trait :repeat do
      repeat_flag { :repeat }
      repeat_tweet_time { "#{Time.current.hour}:00:00".in_time_zone }
      tweet_sun { 1 }
      tweet_mon { 0 }
      tweet_tue { 1 }
      tweet_wed { 0 }
      tweet_thu { 1 }
      tweet_fri { 0 }
      tweet_sat { 1 }
    end

    trait :todo do
      status { :todo }
    end
    trait :done do
      status { :done }
    end
    trait :pause do
      pause_flag { :pause }
    end
    trait :active do
      pause_flag { :active }
    end
    trait :just_tweet_datetime do
      tweet_datetime { Time.current }
    end
    trait :three_minutes_after_tweet_datetime do
      tweet_datetime { Time.current.ago(3.minutes) }
    end
    trait :three_minutes_before_tweet_datetime do
      tweet_datetime { Time.current.since(3.minutes) }
    end
    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end
