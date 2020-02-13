class UsersController < ApplicationController

  def show
    @tasks = current_user.tasks
  end

  def destroy
    current_user.destroy!
    flash[:success] = 'アカウントを削除しました'
    redirect_to :root
  end

end
