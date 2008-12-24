# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def time_ago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601))
  end
  
  def can_edit?(record)
    user_condition = if record.respond_to?(:user) 
      record.user == current_user 
    else
      record == current_user
    end
    current_user && ( user_condition || current_user.admin?)
  end
end
