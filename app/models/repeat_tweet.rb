class RepeatTweet < ApplicationRecord
  belongs_to :task
  validates :tweet_wday, presence: true
  validates :tweet_time, presence: true
end
