class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.one_time?
      save_one_time_tweet(@task)
    elsif @task.repeat?
      save_repeat_tweet(@task)
    else
      redirect_to user_path(@user)
    end
    redirect_to user_path(current_user)
  end

  def edit
  end

  def udpate
  end

  def delete
  end

  def task_params
    params.require(:task).permit(:title, :tweet_content, :repeat_flag, :user_id)
  end

  def one_time_tweet_params
    params.require(:task).permit(:tweet_datetime)
  end

  def repeat_tweet_params
    params.require(:task).permit(:tweet_time)
  end

  def save_one_time_tweet(task)
    errors = []
    ActiveRecord::Base.transaction do
      if !task.save
        errors << task.errors.full_messages
      end
      raise ActiveRecord::Rollback if errors.present?
      one_time_tweet = task.build_one_time_tweet(one_time_tweet_params)
      one_time_tweet.save!
    end
    errors.presence || nil
  end

  def save_repeat_tweet(task)
    errors = []
    wdays = []
    wdays.push(
      params.dig(:task, :sun), params.dig(:task, :mon), params.dig(:task, :tue), params.dig(:task, :wed),
      params.dig(:task, :thu), params.dig(:task, :fri), params.dig(:task, :sat)
    )
    ActiveRecord::Base.transaction do
      if !task.save
        errors << task.errors.full_messages
      end
      raise ActiveRecord::Rollback if errors.present?
      repeat_num = 0
      wdays.each_with_index do |wday, i|
        repeat_tweet = task.repeat_tweets.build(repeat_tweet_params)
        if wday == '1'
          repeat_tweet.tweet_wday = i
          repeat_tweet.save!
          repeat_num += 1
        end
      end
      if repeat_num == 0
        errors << '繰り返す曜日を1つ以上選んでください'
      end
    end
    errors.presence || nil
  end

end
