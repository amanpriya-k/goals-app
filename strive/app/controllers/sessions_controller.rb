class SessionsController < ApplicationController
    before_action :require_login, only: [:logout]
  def new
  end
  
  def create
    user = User.find_by_credentials(params[:username],params[:password])
    if user
      login(user)
      redirect_to user_url(user)
    else
      flash.now[:errors] = ["Invalid login credentials"]
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to new_session_url
  end
end