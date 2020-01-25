class Task < ApplicationRecord
  belongs_to :user
  has_one :one_time_tweet, dependent: :destroy
  has_many :repeat_tweet, dependent: :destroy

  enum repeat_flag: { one_time: 0, repeat: 1 }
  enum pause_flag: { active: 0, pause: 1 }
  enum status: { todo: 0, done: 1 }

  validates :title, presence: true, length: { maximum: 50 }
  validates :tweet_content, presence: true, length: { maximum: 140 }
  validates :repeat_flag, presence: true
  validates :pause_flag, presence: true
  validates :status, presence: true
end
