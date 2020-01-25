class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :tweet_content, null: false
      t.integer :repeat_flag, null: false, default: 0
      t.integer :pause_flag, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
