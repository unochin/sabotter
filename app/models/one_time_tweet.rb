class OneTimeTweet < ApplicationRecord
  belongs_to :task
  validates :tweet_datetime, presence: true
end
