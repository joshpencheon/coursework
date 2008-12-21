class ApplicationController < ActionController::Base
  include AuthenticationMethods

  helper :all 
  
  protect_from_forgery # :secret => '80ff0d816c3903ddea3136e227e27fe8'
  
  filter_parameter_logging :password, :confirm_password
  helper_method :current_user_session, :current_user

  before_filter :add_delay_to_xhr_requests
  
  private
  
  def add_delay_to_xhr_requests
    sleep 1 if request.xhr? 
  end

end