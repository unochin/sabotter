class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    @task.set_next_tweet_date(Time.current)
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
    set_tweet_time(@task)
    @task.assign_attributes(task_update_params)
    @task.set_next_tweet_date(Time.current)
    if @task.save
      render json: {
                    tweet_datetime: @task.tweet_datetime.strftime('%Y-%m-%d %H:%M'),
                    repeat_tweet_time: @task.repeat_tweet_time.strftime('%H:%M'),
                    wdays: [@task.tweet_sun, @task.tweet_mon, @task.tweet_tue, @task.tweet_wed,
                            @task.tweet_thu, @task.tweet_fri, @task.tweet_sat]
                    },
                    status: :ok
    else
      render json: { task: @task, errors: { messages: @task.errors.full_messages } }, status: :bad_request
    end
  end

  def delete; end

  def task_params
    params.require(:task).permit(:title, :tweet_content, :repeat_flag, :tweet_datetime,
                                 :repeat_tweet_time, :tweet_sun, :tweet_mon,
                                 :tweet_tue, :tweet_wed, :tweet_thu, :tweet_fri,
                                 :tweet_sat, :user_id
                                )
  end

  def toggle_pause_flag
    @task = current_user.tasks.find(params[:task_id])
    respond_to do |format|
      if @task.toggle_pause_flag!
        if @task.pause?
          format.js { flash[:success] = 'このタスクを休止しました！' }
        elsif @task.active?
          format.js { flash[:success] = 'このタスクを再開しました！' }
        end
      else
        format.js { flash[:danger] = 'タスクの状態を変更できませんでした' }
      end
    end
  end

  def task_update_params
    params.require(:task).permit(:title, :tweet_content, :tweet_sun, :tweet_mon,
                                 :tweet_tue, :tweet_wed, :tweet_thu, :tweet_fri,
                                 :tweet_sat
                                )
  end

  # jQueryのAjaxメソッドでparamsを取得すると、年、月、日、時、分を個別で取得することになるため、TimeWithZoneクラスのオブジェクトを作成
  def set_tweet_time(task)
    if task.one_time?
      year = params.dig(:task, :tweet_year)
      month = params.dig(:task, :tweet_month)
      day = params.dig(:task, :tweet_day)
      hour = params.dig(:task, :tweet_hour)
      minute = params.dig(:task, :tweet_minute)
      time = Time.zone.parse("#{year}-#{month}-#{day} #{hour}:#{minute}:00")
      task.tweet_datetime = time
    elsif task.repeat?
      hour = params.dig(:task, :repeat_hour)
      minute = params.dig(:task, :repeat_minute)
      time = Time.zone.parse("#{hour}:#{minute}:00")
      task.repeat_tweet_time = time
    end
  end

end
