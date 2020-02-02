require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) {create(:test_user)}
  let(:one_time_task) {create(:one_time_test_task)}
  let(:repeat_task) {create(:repeat_test_task)}

  describe 'ログイン後' do
    before do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'Login'
      sleep 0.5
      visit user_path
      sleep 0.5
    end

    context 'フォームの入力値が正常' do
      context '繰り返しなしのタスクを登録' do
        fit 'タスクが登録されタスク一覧に追加される', js: true do
          click_link nil, href: new_user_task_path
          sleep 0.5
          fill_in 'Title', with: '朝走る'
          fill_in 'Tweet content', with: '走るのサボってしまいました'
          sleep 0.5
          select 2021, from: 'task_tweet_datetime_1i'
          select 12, from: 'task_tweet_datetime_2i'
          select 15, from: 'task_tweet_datetime_3i'
          select 13, from: 'task_tweet_datetime_4i'
          # fill_in 'Tweet datetime', with: Time.current.since(1.hour)
          click_button 'Save'
          expect(page).to have_content '朝走る'
          find('.js-showMoreInfo').click
          sleep 0.5
          expect(page).to have_content '走るのサボってしまいました'
        end
      end

      context '繰り返しありのタスクを登録' do
        fit 'タスクが登録されタスク一覧に追加される', js: true do
          click_link nil, href: new_user_task_path
          sleep 0.5
          check 'repeat'
          check 'Wed'
          fill_in 'Title', with: '毎日走る'
          fill_in 'Tweet content', with: '走るのサボってしまいました'
          sleep 0.5
          select 13, from: 'task_repeat_tweet_time_4i'
          select 30, from: 'task_repeat_tweet_time_5i'
          click_button 'Save'
          expect(page).to have_content '水'
          expect(page).to have_content '毎日走る'
          find('.js-showMoreInfo').click
          sleep 0.5
          expect(page).to have_content '走るのサボってしまいました'
        end
      end
    end
  end
end
