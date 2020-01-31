class UsersController < ApplicationController

  def show
    @tasks = current_user.tasks
  end

  def destroy
    if current_user.destroy!
      flash[:success] = 'アカウントを削除しました'
      redirect_to :root
    else
      flash[:danger] = 'アカウントを削除できませんでした'
      render :show
    end
  end

end
