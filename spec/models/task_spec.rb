require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:one_time_task) { build(:task, :one_time_task) }
  let(:repeat_task) { build(:task, :repeat_task) }

  context '全ての属性値が正常なとき' do
    context 'ど正常'
      it 'バリデーションが通ること' do
        expect(one_time_task).to be_valid
      end
    context 'repeat_taskで一つの曜日が1のとき' do
      it 'バリデーションが通ること' do
        repeat_task.tweet_sun = 0
        repeat_task.tweet_mon = 0
        repeat_task.tweet_tue = 0
        repeat_task.tweet_wed = 1
        repeat_task.tweet_thu = 0
        repeat_task.tweet_fri = 0
        repeat_task.tweet_sat = 0
        expect(repeat_task).to be_valid
      end
    end
    context 'tweet_datetimeが現在時刻より少しでも未来のとき' do
      it 'バリデーションが通ること' do
        one_time_task.tweet_datetime = Time.current.since(1.minute)
        expect(one_time_task).to be_valid
      end
    end
  end

  context 'ある属性値が不正なとき' do
    context 'titleがnullのとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.title = nil
        one_time_task.valid?
        expect(one_time_task.errors[:title]).to include('を入力してください')
      end
    end
    context 'tweet_contentがnullのとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.tweet_content = nil
        one_time_task.valid?
        expect(one_time_task.errors[:tweet_content]).to include('を入力してください')
      end
    end
    context 'tweet_datetimeがnullのとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.tweet_datetime = nil
        one_time_task.valid?
        expect(one_time_task.errors[:tweet_datetime]).to include('を入力してください')
      end
    end
    context 'repeat_flagがnullのとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.repeat_flag = nil
        one_time_task.valid?
        expect(one_time_task.errors[:repeat_flag]).to include('を入力してください')
      end
    end
    context 'pause_flagがnullのとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.pause_flag = nil
        one_time_task.valid?
        expect(one_time_task.errors[:pause_flag]).to include('を入力してください')
      end
    end
    context 'statusがnullのとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.status = nil
        one_time_task.valid?
        expect(one_time_task.errors[:status]).to include('を入力してください')
      end
    end
    context 'repeat_taskでtweet_timeがnullのとき' do
      it 'バリデーションが通らないこと' do
        repeat_task.status = nil
        repeat_task.valid?
        expect(repeat_task.errors[:status]).to include('を入力してください')
      end
    end
    context 'repeat_taskで繰り返しの曜日が全て0のとき' do
      it 'バリデーションが通らないこと' do
        repeat_task.tweet_sun = 0
        repeat_task.tweet_mon = 0
        repeat_task.tweet_tue = 0
        repeat_task.tweet_wed = 0
        repeat_task.tweet_thu = 0
        repeat_task.tweet_fri = 0
        repeat_task.tweet_sat = 0
        repeat_task.valid?
        expect(repeat_task.errors[:repeat_flag]).to include('は一つ以上の曜日を設定してください')
      end
    end
    context 'tweet_datetimeが現在と同時刻のとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.tweet_datetime = Time.current
        one_time_task.valid?
        expect(one_time_task.errors[:tweet_datetime]).to include('は現在時刻より未来に設定してください')
      end
    end
    context 'tweet_datetimeが現在時刻より前のとき' do
      it 'バリデーションが通らないこと' do
        one_time_task.tweet_datetime = Time.current.ago(1.minute)
        one_time_task.valid?
        expect(one_time_task.errors[:tweet_datetime]).to include('は現在時刻より未来に設定してください')
      end
    end
  end
end
