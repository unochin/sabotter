class UserSessionsController < ApplicationController
  def create
    @user = login(params[:email], params[:password])

    if @user
      # redirect_to user_path
      redirect_to root_url
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:users, notice: 'Logged out!')
  end
end
