# Reopen from acts_as_taggable_on_steriods
Tag.class_eval do
  
  before_save do |tag|
    tag.name.downcase!
  end
  
  def to_param
    "#{id}-#{name.gsub(/[^a-z]/, ' ').strip.gsub(/\s+/, '-')}"
  end
end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  
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
  
  def relative_time(time, options = {})
    options[:class] ||= "relative_time"
    options[:class] += '_later' if options.delete(:later)
    defaults = { :title => time.getutc.iso8601, :style => 'display:none' }
    content_tag(:abbr, time.to_s, options.merge(defaults)) if time
  end
end
