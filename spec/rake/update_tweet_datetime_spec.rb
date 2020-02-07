require 'rake_helper'

describe 'update_tweet_datetime:update_tweet_datetime' do
  context '期限が過ぎた、activeかつtodoのタスクが存在する' do
    let!(:user) { create(:user) }
    let!(:expired_active_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :active, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:expired_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :pause, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }
    let!(:expired_done_repeat_task) { create(:task_for_rake, :repeat, :done, :three_minutes_after_tweet_datetime, :skip_validate, user: user) }

    let!(:not_expired_active_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :active, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:not_expired_pause_todo_repeat_task) { create(:task_for_rake, :repeat, :todo, :pause, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }
    let!(:not_expired_done_repeat_task) { create(:task_for_rake, :repeat, :done, :three_minutes_before_tweet_datetime, :skip_validate, user: user) }

    subject(:update_tweet_datetime) { Rake.application['update_tweet_datetime:update_tweet_datetime'] }

    it '期限が過ぎた、activeかつtodoのタスクのみが対象メソッドが呼び出すこと' do
      allow(expired_active_todo_repeat_task).to receive(:set_next_tweet_date)
      allow(expired_pause_todo_repeat_task).to receive(:set_next_tweet_date)
      allow(expired_done_repeat_task).to receive(:set_next_tweet_date)
      allow(not_expired_active_todo_repeat_task).to receive(:set_next_tweet_date)
      allow(not_expired_pause_todo_repeat_task).to receive(:set_next_tweet_date)
      allow(not_expired_done_repeat_task).to receive(:set_next_tweet_date)

      update_tweet_datetime.invoke

      expect(expired_active_todo_repeat_task).to have_received(:set_next_tweet_date).once
      expect(expired_pause_todo_repeat_task).to have_received(:set_next_tweet_date).at_most(0).times
      expect(expired_done_repeat_task).to have_received(:set_next_tweet_date).at_most(0).times
      expect(not_expired_active_todo_repeat_task).to have_received(:set_next_tweet_date).at_most(0).times
      expect(not_expired_pause_todo_repeat_task).to have_received(:set_next_tweet_date).at_most(0).times
      expect(not_expired_done_repeat_task).to have_received(:set_next_tweet_date).at_most(0).times
    end
  end
end
