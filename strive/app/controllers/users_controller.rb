class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:session_token] = @user.reset_session_token
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Invalid username or password"]
      render :new
    end
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def edit
    @user = User.find_by(id: params[:id])
    render :edit
  end
  
  def update
    # byebug
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Invalid username or password"]
      render :edit
    end
  end
  
  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    render :new
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username,:password)
  end
end