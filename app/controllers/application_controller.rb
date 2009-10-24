class ApplicationController < ActionController::Base
  include AuthenticationMethods

  helper :all 
  
  protect_from_forgery # :secret => '80ff0d816c3903ddea3136e227e27fe8'
  
  filter_parameter_logging :password, :confirm_password
  helper_method :current_user_session, :current_user

  before_filter :add_delay_to_xhr_requests
  
  private
  
  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "/usr/bin/rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end
  
  def can_edit?(record)
    current_user && (current_user.admin? || current_user == record.try(:user))
  end
  helper_method :can_edit?
  
  def add_delay_to_xhr_requests
    if request.xhr? && ENV['RAILS_ENV'] == 'development'
      sleep 1 
      RAILS_DEFAULT_LOGGER.debug("\n***   LOCAL AJAX REQUEST - SIMULATE DELAY\n\n")
    end
  end

end