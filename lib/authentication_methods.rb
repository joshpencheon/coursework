module AuthenticationMethods
  
  private
  
  def authorize
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to continue"
      redirect_to new_user_session_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri unless request.xhr?
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