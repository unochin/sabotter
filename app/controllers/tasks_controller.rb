class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    respond_to do |format|
      if @task.save
        format.js { flash[:success] = 'タスクを作成しました！' }
      else
        format.js { flash[:danger] = 'タスクを作成できませんでした' }
      end
    end
  end

  def edit; end

  def update
    @task = current_user.tasks.find(params[:id])
    tweet_year = params.dig(:task, :tweet_date_year) || '1999'
    tweet_month = params.dig(:task, :tweet_date_month) || '01'
    tweet_day = params.dig(:task, :tweet_date_day) || '01'
    tweet_hour = params.dig(:task, :tweet_time_hour) || '01'
    tweet_minute = params.dig(:task, :tweet_time_minute) || '01'
    time = Time.zone.parse("#{tweet_year}-#{tweet_month}-#{tweet_day} #{tweet_hour}:#{tweet_minute}:00")
    puts time.to_s
    wdays =[]
    wdays.push(params.dig(:task, :sun), params.dig(:task, :mon), params.dig(:task, :tue), params.dig(:task, :wed),
               params.dig(:task, :thu), params.dig(:task, :fri), params.dig(:task, :sat)
              )

    if @task.one_time?
      @task.one_time_tweet.tweet_datetime = time
      @task.title = params.dig(:task, :title)
      @task.tweet_content = params.dig(:task, :tweet_content)
    elsif @task.repeat?
      # 更新前はチェックされていた曜日で、更新後チェックが外されたものはレコード削除
      @task.repeat_tweets.each do |repeat|
        if (repeat.tweet_wday == 0) && (wdays[0] == 0)
          repeat.destroy!
        elsif (repeat.tweet_wday == 1) && (wdays[1] ==0)
          repeat.destroy!
        elsif (repeat.tweet_wday == 2) && (wdays[2] ==0)
          repeat.destroy!
        elsif (repeat.tweet_wday == 3) && (wdays[3] ==0)
          repeat.destroy!
        elsif (repeat.tweet_wday == 4) && (wdays[4] ==0)
          repeat.destroy!
        elsif (repeat.tweet_wday == 5) && (wdays[5] ==0)
          repeat.destroy!
        elsif (repeat.tweet_wday == 6) && (wdays[6] ==0)
          repeat.destroy!
        end
        repeat.tweet_time = time
      end

      # フォームで選択された曜日で、DBに無い曜日は登録する
      wday_flag = 0   # このフラグが1になればすでに登録されていた曜日
      wdays.each_with_index do |wday, i|
        if wday == 1
          @task.repeat_tweets.each do |repeat|
            if repeat.tweet_wday == i
              wday_flag = 1
              break
            end
          end
          if wday_flag == 0
            @task.build(tweet_time: time, tweet_wday: i)
          end
          wday_flag = 0
        end
      end
    end

    if @task.save
      render json: { task: @task }, status: :ok
    else
      render json: { task: @task, errors: { messages: @task.errors.full_messages } }, status: :bad_request
    end
    puts 'hi!!!!'
  end

  def delete; end

  def task_params
    params.require(:task).permit(:title, :tweet_content, :repeat_flag, :tweet_datetime,
                                 :repeat_tweet_time, :tweet_sun, :tweet_mon,
                                 :tweet_tue, :tweet_wed, :tweet_thu, :tweet_fri,
                                 :tweet_sat, :user_id
                                )
  end
end
