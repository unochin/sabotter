class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.datetime :tweet_datetime, null:false
      t.time :tweet_time
      t.integer :repeat_flag, null: false, default: 0
      t.integer :tweet_sun
      t.integer :tweet_mon
      t.integer :tweet_tue
      t.integer :tweet_wed
      t.integer :tweet_thu
      t.integer :tweet_fri
      t.integer :tweet_sat
      t.text :tweet_content, null: false
      t.integer :status, null: false, default: 0
      t.integer :pause_flag, null: false, default: 0
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
