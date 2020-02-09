require 'rake_helper'

describe 'update_tweet_datetime:update_tweet_datetime' do
  context '期限が過ぎたタスクと過ぎていないタスクが存在する' do
    let!(:user) { create(:user) }
    let!(:expired_active_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :active, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:expired_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :pause, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:expired_done_repeat_task) { create(:task_for_rake, :repeat, :done, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }

    let!(:not_expired_active_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :active, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:not_expired_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :pause, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:not_expired_done_repeat_task) { create(:task_for_rake, :repeat, :done, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }

    subject(:update_tweet_datetime) { Rake.application['update_tweet_datetime:update_tweet_datetime'] }

    it '期限が過ぎたタスクの次回ツイート時間が更新されること' do

      tasks = [
              expired_active_todo_repeat_task,
              expired_pause_todo_repeat_task,
              expired_done_repeat_task,
              not_expired_active_todo_repeat_task,
              not_expired_pause_todo_repeat_task,
              not_expired_done_repeat_task,
              ]

      # Array => ActiveRecord_Relation
      tasks = Task.where(id: tasks.map{ |task| task.id })
      # ActiveRecord_Relation => Array
      repeat_tasks = tasks.repeat.to_a

      # rakeタスク実行前ツイート時間格納用
      before_task_0_tweet_datetime = 0
      before_task_1_tweet_datetime = 0
      before_task_2_tweet_datetime = 0
      before_task_3_tweet_datetime = 0
      before_task_4_tweet_datetime = 0
      before_task_5_tweet_datetime = 0
      # rakeタスク実行後ツイート時間格納用
      after_task_0_tweet_datetime = 0
      after_task_1_tweet_datetime = 0
      after_task_2_tweet_datetime = 0
      after_task_3_tweet_datetime = 0
      after_task_4_tweet_datetime = 0
      after_task_5_tweet_datetime = 0

      repeat_tasks.each_with_index do |task, index|
        var = "before_task_#{index}_tweet_datetime"
        value = task.tweet_datetime.year.to_s + task.tweet_datetime.month.to_s + task.tweet_datetime.day.to_s \
                + task.tweet_datetime.hour.to_s + task.tweet_datetime.min.to_s
        eval("#{var} = #{value}")
      end

      allow(Task).to receive(:repeat).and_return(repeat_tasks)

      update_tweet_datetime.invoke

      repeat_tasks.each_with_index do |task, index|
        var = "after_task_#{index}_tweet_datetime"
        value = task.tweet_datetime.year.to_s + task.tweet_datetime.month.to_s + task.tweet_datetime.day.to_s \
                + task.tweet_datetime.hour.to_s + task.tweet_datetime.min.to_s
        eval("#{var} = #{value}")
      end

      expect(before_task_0_tweet_datetime != after_task_0_tweet_datetime).to eq true
      expect(before_task_1_tweet_datetime != after_task_1_tweet_datetime).to eq true
      expect(before_task_2_tweet_datetime != after_task_2_tweet_datetime).to eq true
      expect(before_task_3_tweet_datetime == after_task_3_tweet_datetime).to eq true
      expect(before_task_4_tweet_datetime == after_task_4_tweet_datetime).to eq true
      expect(before_task_5_tweet_datetime == after_task_5_tweet_datetime).to eq true
    end
  end
end
