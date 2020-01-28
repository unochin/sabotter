class UsersController < ApplicationController

  def show
    @tasks = current_user.tasks
  end
end
