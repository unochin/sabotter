require 'rake_helper'

describe 'auto_tweet:auto_tweet' do
  context '期限が過ぎている・過ぎていない、休止中・休止していない、todo・done、様々な組み合わせのタスクが存在する' do
    let!(:user) { create(:user) }
    let!(:just_active_todo_repeat_task) { create(:task_for_rake, :repeat, :active, :todo, :just_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_after_active_todo_repeat_task) { create(:task_for_rake, :repeat, :active, :todo, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_before_active_todo_repeat_task) { create(:task_for_rake, :repeat, :active, :todo, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:just_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :pause, :todo, :just_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_after_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :pause, :todo, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_before_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :pause, :todo, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:just_active_done_repeat_task) { create(:task_for_rake, :repeat, :active, :done, :just_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_after_active_done_repeat_task) { create(:task_for_rake, :repeat, :active, :done, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_before_active_done_repeat_task) { create(:task_for_rake, :repeat, :active, :done, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:just_active_done_one_time_task) { create(:task_for_rake, :one_time, :active, :done, :just_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_after_active_done_one_time_task) { create(:task_for_rake, :one_time, :active, :done, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:three_minutes_before_active_done_repeat_task) { create(:task_for_rake, :one_time, :active, :done, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }

    subject(:auto_tweet) { Rake.application['auto_tweet:auto_tweet'] }

    it '期限が過ぎた、activeかつtodoのタスクのみがツイートをすること' do
      tasks = [
              just_active_todo_repeat_task,
              three_minutes_after_active_todo_repeat_task,
              three_minutes_before_active_todo_repeat_task,
              just_pause_todo_repeat_task,
              three_minutes_after_pause_todo_repeat_task,
              three_minutes_before_pause_todo_repeat_task,
              just_active_done_repeat_task,
              three_minutes_after_active_done_repeat_task,
              three_minutes_before_active_done_repeat_task,
              just_active_done_one_time_task,
              three_minutes_after_active_done_one_time_task,
              three_minutes_before_active_done_repeat_task
              ]

      # Array => ActiveRecord_Relation
      tasks = Task.where(id: tasks.map{ |task| task.id })
      # ActiveRecord_Relation => Array
      tweet_tasks = tasks.have_to_tweet.to_a

      twitter_client_mock = double('Twitter client')
      allow(twitter_client_mock).to receive(:update!)

      tweet_tasks.each do |tweet_task|
        allow(tweet_task).to receive(:twitter_client).and_return(twitter_client_mock)
      end

      allow(Task).to receive(:have_to_tweet).and_return(tweet_tasks)

      auto_tweet.invoke

      expect(twitter_client_mock).to have_received(:update!).exactly(Task.have_to_tweet.count).times
    end
  end
end
