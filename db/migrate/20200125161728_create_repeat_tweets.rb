class CreateRepeatTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :repeat_tweets do |t|
      t.references :task, foreign_key: true
      t.time :tweet_time, null:false
      t.integer :tweet_wday, null:false

      t.timestamps
    end
  end
end
