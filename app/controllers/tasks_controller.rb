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

  def update; end

  def delete; end

  def task_params
    params.require(:task).permit(:title, :tweet_content, :repeat_flag, :tweet_datetime,
                                 :repeat_tweet_time, :tweet_sun, :tweet_mon,
                                 :tweet_tue, :tweet_wed, :tweet_thu, :tweet_fri,
                                 :tweet_sat, :user_id
                                )
  end
end
