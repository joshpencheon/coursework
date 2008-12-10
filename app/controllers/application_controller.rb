class ApplicationController < ActionController::Base
  include AuthenticationMethods

  helper :all 
  
  protect_from_forgery # :secret => '80ff0d816c3903ddea3136e227e27fe8'
  
  filter_parameter_logging :password, :confirm_password
  helper_method :current_user_session, :current_user

end

class ActiveRecord::Base
  def self.create_events(included_assocations)
    class_eval <<-END 
      attr_accessor  :dumped_event_data 
      attr_protected :dumped_event_data
    END
 
    news = EventCreator.new(included_assocations)
    
    before_save news
    after_save  news
  end
end