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

  # 次にツイートする曜日を取得
  def calc_next_tweet_wday(base_wday)
    tweet_wdays = [tweet_sun, tweet_mon, tweet_tue, tweet_wed, tweet_thu, tweet_fri, tweet_sat]
    next_tweet_wday = -1
    tweet_wdays.each_with_index do |wday, i|
      if i <= base_wday
        next
      end
      if wday == 1
        next_tweet_wday = i
        break
      end
    end
    if next_tweet_wday == -1
      tweet_wdays.each_with_index do |wday, j|
        if wday == 1
          next_tweet_wday = j
          break
        end
      end
    end
    next_tweet_wday
  end

  # 次にツイートする日時を取得
  def set_next_tweet_date(base_day)
    if one_time?
      return
    end
    wdays = %i[sunday monday tuesday wednesday thursday friday saturday]
    tweet_wdays = [
                   tweet_sun, tweet_mon, tweet_tue, tweet_wed, tweet_thu, tweet_fri, tweet_sat
                  ]
    tweet_time = self.repeat_tweet_time.to_s.split[1]
    today = Time.current.to_date.to_s
    today_tweet_datetime = (today + ' ' + tweet_time).in_time_zone
    base_day_string = base_day.to_s
    base_day_tweet_datetime = (base_day_string + ' ' + tweet_time).in_time_zone

    if tweet_wdays[base_day.wday] == 1 && Time.current < base_day_tweet_datetime
      self.tweet_datetime = today_tweet_datetime
    else
      next_tweet_wday = self.calc_next_tweet_wday(Time.current.wday)
      # 基準となる日からみて、次の〇曜日の日付を取得
      next_tweet_day = base_day.beginning_of_week(wdays[next_tweet_wday]).since(1.week).to_date.to_s
      self.tweet_datetime = (next_tweet_day + ' ' + tweet_time).in_time_zone
    end
  end

end
