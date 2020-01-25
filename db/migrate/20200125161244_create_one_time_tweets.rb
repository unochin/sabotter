class CreateOneTimeTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :one_time_tweets do |t|
      t.references :task, foreign_key: true
      t.datetime :tweet_datetime, null:false
      t.timestamps
    end
  end
end
