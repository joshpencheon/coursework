class ApplicationController < ActionController::Base
  helper :all 
  
  protect_from_forgery # :secret => '80ff0d816c3903ddea3136e227e27fe8'
  
  filter_parameter_logging :password, :confirm_password
  helper_method :current_user_session, :current_user

  private
  
  def authorize
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
end
