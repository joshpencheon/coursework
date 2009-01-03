# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def time_ago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601))
  end
  
  def truncate_centrally(string, length, truncate_string = '...')
    return string if string.length <= length
    length_from_string = length - truncate_string.length
    return truncate(string, length, truncate_string) unless length_from_string >= 1
    if length_from_string % 2 == 0
      left  = length_from_string / 2
      right = left
    else
      left  = (length_from_string + 1) / 2
      right = (length_from_string - 1) / 2
    end
    string[0, left] + truncate_string + string[-right, right]
  end
end
