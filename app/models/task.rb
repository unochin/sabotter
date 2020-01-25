class Task < ApplicationRecord
  belongs_to :user

  enum repeat_flag: { one_time: 0, repeat: 1 }
  enum tweet_sun: { no_tweet_sun: 0, tweet_sun: 1 }
  enum tweet_sun: { no_tweet_mon: 0, tweet_mon: 1 }
  enum tweet_sun: { no_tweet_tue: 0, tweet_tue: 1 }
  enum tweet_sun: { no_tweet_wed: 0, tweet_wed: 1 }
  enum tweet_sun: { no_tweet_thu: 0, tweet_thu: 1 }
  enum tweet_sun: { no_tweet_fri: 0, tweet_fri: 1 }
  enum tweet_sun: { no_tweet_sat: 0, tweet_sat: 1 }
  enum pause_flag: { active: 0, pause: 1 }
  enum status: { todo: 0, done: 1 }

  validates :title, presence: true, maximum: { maximum: 50 }
  validates :tweet_datetime, presence: true
  validates :repeat_flag, presence: true
  validates :tweet_content, presence: true, length: { maximum: 140 }
  validates :status, presence: true
  validates :pause_flag, presence: true
end
