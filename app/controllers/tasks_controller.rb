class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    respond_to do |format|
      if @task.one_time?
        # エラーメッセージがなければtask作成成功
        if !save_one_time_tweet(@task)
          format.js { flash[:success] = 'タスクを作成しました！' }
        else
          format.js { flash[:danger] = 'タスクを作成できませんでした' }
        end
      elsif @task.repeat?
        # エラーメッセージがなければtask作成成功
        if !save_repeat_tweet(@task)
          format.js { flash[:success] = 'タスクを作成しました！' }
        else
          format.js { flash[:danger] = 'タスクを作成できませんでした' }
        end
      else
        format.js { flash[:danger] = 'タスクを作成できませんでした' }
      end
    end
  end

  def edit; end

  def udpate; end

  def delete; end

  def task_params
    params.require(:task).permit(:title, :tweet_content, :repeat_flag, :user_id)
  end

  def one_time_tweet_params
    params.require(:task).permit(:tweet_datetime)
  end

  def repeat_tweet_params
    params.require(:task).permit(:tweet_time)
  end

  # 繰り返しなしのタスク作成
  def save_one_time_tweet(task)
    @errors = nil
    ActiveRecord::Base.transaction do
      if !task.save
        @errors = task.errors.full_messages
      end
      # tasksテーブルとone_time_tweetsテーブルへinsert
      raise ActiveRecord::Rollback if @errors.present?
      one_time_tweet = task.build_one_time_tweet(one_time_tweet_params)
      unless one_time_tweet.save
        @errors = ['タスクの作成はできませんでした']
      end
      raise ActiveRecord::Rollback if @errors.present?
    end
    @errors.presence || nil
  end

  # 繰り返しありのタスク作成
  def save_repeat_tweet(task)
    @errors = nil
    wdays = []
    wdays.push(
      params.dig(:task, :sun), params.dig(:task, :mon), params.dig(:task, :tue), params.dig(:task, :wed),
      params.dig(:task, :thu), params.dig(:task, :fri), params.dig(:task, :sat)
    )
    # tasksテーブルとrepeat_tweetsテーブルへinsert
    ActiveRecord::Base.transaction do
      if !task.save
        @errors = task.errors.full_messages
      end
      raise ActiveRecord::Rollback if @errors.present?
      repeat_num = 0
      wdays.each_with_index do |wday, i|
        repeat_tweet = task.repeat_tweets.build(repeat_tweet_params)
        if wday == '1'
          repeat_tweet.tweet_wday = i
          if repeat_tweet.save
            repeat_num += 1
          else
            @errors = ['タスクの作成はできませんでした']
          end
        end
      end
      raise ActiveRecord::Rollback if @errors.present?
      if repeat_num == 0
        @errors = ['繰り返す曜日を1つ以上選んでください']
      end
      raise ActiveRecord::Rollback if @errors.present?
    end
    @errors.presence || nil
  end

end
