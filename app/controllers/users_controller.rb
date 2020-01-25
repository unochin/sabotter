class UsersController < ApplicationController

  def show
    @tasks = current_user.tasks
    @task = Task.new
  end
end
