class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  # before_action :require_login
  
  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def login(user)
    session[:session_token] = user.reset_session_token
    current_user
  end
  
  def logout 
    current_user.reset_session_token
    session[:session_token] = nil
    @current_user = nil
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    redirect_to new_session_url unless logged_in?
  end
  
  # def require_logout
  #   redirect_to new_session_url if logged_in?
  # end
end
