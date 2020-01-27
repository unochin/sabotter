class Task < ApplicationRecord
  belongs_to :user
  has_one :one_time_tweet, dependent: :destroy
  has_many :repeat_tweets, dependent: :destroy

  enum repeat_flag: { one_time: 0, repeat: 1 }
  enum pause_flag: { active: 0, pause: 1 }
  enum status: { todo: 0, done: 1 }

  validates :title, presence: true, length: { maximum: 50 }
  validates :tweet_content, presence: true, length: { maximum: 140 }
  validates :repeat_flag, presence: true
  validates :pause_flag, presence: true
  validates :status, presence: true
  validate :at_least_one_1, if: :repeat?

  def at_least_one_1
    wdays = []
    wdays.push(
              self.tweet_sun,
              self.tweet_mon,
              self.tweet_tue,
              self.tweet_wed,
              self.tweet_thu,
              self.tweet_fri,
              self.tweet_sat
              )
    if wdays.all? { |wday| wday == 0 }
      errors.add(:repeat_flag, "は一つ以上の曜日を設定してください")
    end
  end

end
