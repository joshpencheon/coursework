# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def time_ago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601))
  end
end
