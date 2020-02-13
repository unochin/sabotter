require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }
  let(:one_time_task) { create(:task, :one_time_task, user: user) }
  let(:repeat_task) { create(:task, :repeat_task, user: user) }

  describe '正常系' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end
    context '繰り返しなしのタスク' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される', js: true do
          visit user_path
          click_link nil, href: new_user_task_path
          fill_in 'Title', with: one_time_task.title
          fill_in 'Tweet content', with: one_time_task.tweet_content
          select one_time_task.tweet_datetime.year, from: 'task_tweet_datetime_1i'
          select one_time_task.tweet_datetime.month, from: 'task_tweet_datetime_2i'
          select  one_time_task.tweet_datetime.day, from: 'task_tweet_datetime_3i'
          select format('%02d', one_time_task.tweet_datetime.hour), from: 'task_tweet_datetime_4i'
          select format('%02d', one_time_task.tweet_datetime.min), from: 'task_tweet_datetime_5i'
          click_button 'Save'
          expect(page).to have_content 'タスクを作成しました！'
          expect(all(:css, '.task-wrapper')[0].has_text?(one_time_task.title)).to be true
          first('.js-showMoreInfo').click
          expect(all(:css, '.task-wrapper')[0].has_text?(one_time_task.tweet_content)).to be true
          expect(all(:css, '.task-wrapper')[0].has_text?(one_time_task.tweet_datetime.strftime('%Y-%m-%d %H:%M'))).to be true
        end
      end

      context 'タスクを編集(タイトル, ツイート内容)' do
        it '編集した内容が反映される', js: true do
          one_time_task
          updated_title = 'updated title'
          updated_tweet_content = 'updated tweet content'
          updated_tweet_datetime = one_time_task.tweet_datetime.since(1.year)
          updated_tweet_datetime = updated_tweet_datetime.ago(2.months)
          updated_tweet_datetime = updated_tweet_datetime.since(1.day)
          updated_tweet_datetime = updated_tweet_datetime.since(1.hour)
          updated_tweet_datetime = updated_tweet_datetime.since(30.minutes)

           visit user_path
           first('.js-showMoreInfo').click
           first('.js-taskEdit').click
           select updated_tweet_datetime.year, from: "_js-editTweetDateTime-#{one_time_task.id}_1i"
           select updated_tweet_datetime.month, from: "_js-editTweetDateTime-#{one_time_task.id}_2i"
           select updated_tweet_datetime.day, from: "_js-editTweetDateTime-#{one_time_task.id}_3i"
           select format('%02d', updated_tweet_datetime.hour), from: "_js-editTweetDateTime-#{one_time_task.id}_4i"
           select format('%02d', updated_tweet_datetime.min), from: "_js-editTweetDateTime-#{one_time_task.id}_5i"
           fill_in "js-editTitle-#{one_time_task.id}", with: updated_title
           fill_in "js-editTweetContent-#{one_time_task.id}", with: updated_tweet_content
           all(:css, '.js-taskUpdate')[0].click
           expect(page).to have_content 'タスクを更新しました'
           expect(all(:css, '.task-wrapper')[0].has_text?(updated_title)).to be true
           expect(all(:css, '.task-wrapper')[0].has_text?(updated_tweet_content)).to be true
           expect(all(:css, '.task-wrapper')[0].has_text?(updated_tweet_datetime.strftime('%Y-%m-%d %H:%M'))).to be true
        end
      end

      context 'タスクを削除' do
        it 'タスク一覧画面からタスクが削除される', js: true do
          one_time_task
          task_id = one_time_task.id
          visit user_path
          first('.js-showMoreInfo').click
          first('.js-taskDelete').click
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'タスクを削除しました'
          expect(page).not_to have_selector "#js-task-#{task_id}"
        end
      end
    end

    context '繰り返しありのタスク' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される', js: true do
          visit user_path
          click_link nil, href: new_user_task_path
          title = 'test title'
          tweet_content = 'test tweet content'
          tweet_time = "#{Time.current.hour}:30:00".in_time_zone
          fill_in 'Title', with: title
          check 'repeat'
          check 'Sun'
          check 'Tue'
          check 'Thu'
          check 'Sat'
          select format('%02d', tweet_time.hour), from: 'task_repeat_tweet_time_4i'
          select format('%02d', tweet_time.min), from: 'task_repeat_tweet_time_5i'
          fill_in 'Tweet content', with: tweet_content
          click_button 'Save'
          expect(page).to have_content 'タスクを作成しました！'
          expect(all(:css, '.task-wrapper')[0].has_text?(title)).to be true
          first('.js-showMoreInfo').click
          expect(all(:css, '.task-wrapper')[0].has_text?(tweet_content)).to be true
          expect(all(:css, '.task-wrapper')[0].has_text?(tweet_time.strftime('%H:%M'))).to be true
          expect(all(:css, '.sun')[0].has_text?('日')).to be true
          expect(all(:css, '.tue')[0].has_text?('火')).to be true
          expect(all(:css, '.thu')[0].has_text?('木')).to be true
          expect(all(:css, '.sat')[0].has_text?('土')).to be true
        end
      end

      context 'タスクを編集(ツイート時間)' do
        it '編集した時間、次回のツイート時間に反映される', js: true do
          repeat_task
          updated_tweet_time = repeat_task.repeat_tweet_time.since(1.hour)
          updated_tweet_time = updated_tweet_time.since(30.minutes)
          visit user_path
          first('.js-showMoreInfo').click
          first('.js-taskEdit').click
          select format('%02d', updated_tweet_time.hour), from: "_js-editTweetTime-#{repeat_task.id}_4i"
          select format('%02d', updated_tweet_time.min), from: "_js-editTweetTime-#{repeat_task.id}_5i"
          all(:css, '.js-taskUpdate')[0].click
          expect(page).to have_content 'タスクを更新しました'
          expect(all(:css, '.repeat-time')[0].has_text?(updated_tweet_time.strftime('%H:%M'))).to be true
        end
      end
      # TODO
      context 'タスクを編集(繰り返しの曜日)' do
        xit '編集した曜日、次回のツイート時間に反映される' do
        end
      end
      # TODO
      context 'タスクを編集(ツイート時間, 繰り返しの曜日)' do
        xit 'ツイート時間, 曜日、次回のツイート時間に反映される' do
        end
      end
    end
  end
end
