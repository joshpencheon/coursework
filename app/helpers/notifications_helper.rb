module NotificationsHelper
  def read_link(notification)
    text = notification.read? ? "Mark as unread" : "Mark as read"
    # text += image_tag 'spinner.gif', :style => 'width: 10px;display:none'
    link_to text, read_notification_path(notification), :class => 'read_link'
  end
  
  def notification_div_for(notification, options = {}, &block)
    if notification.read?
      options[:class] ||= ''
      options[:class] += ' read'
    end
    
    div_for(notification, options, &block)
  end
  
  def hidden_span_if(condition, options = {}, &block)
    options[:style] ||= ''
    options[:style] += ';display:none;' if condition
    
    concat content_tag(:span, capture(&block), options)
  end
  
  def event_title_for(event, options = {})
    user = User.find_by_id(event.user_id)
    parts = [ user.name(:short), event.title.first, event.title.second, "'#{event.title.last}'" ]
    
    if options[:user_link] 
      parts.shift
      parts.unshift(link_to(user.name, user))
    end
    
    parts.join(' ')
  end
  
  def event_items_for(event)
    return build_comment_event(event) if event.data.is_a?(String) 
    
    return_html = ''
    event.data.each_pair do |assoc, types|
      html = content_tag(:li, assoc.to_s.humanize, :class => 'section')
    
      if types.is_a?(Hash) 
        types.each_pair do |type, changes|
          if type.is_a?(Integer)
            instance = assoc.to_s.singularize.camelize.constantize.find_by_id(type)
            string = if instance
              "#{instance.title}: #{changes}"
            else
              "One of the #{assoc.to_s.humanize.downcase.pluralize} was edited. (No more information available.)"              
            end
            html << content_tag(:li, string, :class => 'edited')          
          else
            klass = type == :new ? 'new' : 'deleted'
            [ changes ].flatten.each do |change|
              html << content_tag(:li, change, :class => klass )              
            end
          end
        end        
      else
        html << content_tag(:li, types, :class => 'edited')
      end
      return_html << content_tag(:ul, html, :class => 'notification_items')
    end
    return_html
  end
  
  private
  
  def build_comment_event(event)
    comment = Comment.find_by_id(event.data)
    string = "&#8220;#{truncate(comment.content, 50)}&#8221;" rescue 'This comment has since been deleted.'
    html = content_tag :p, string, :class => 'quote'
  end

end
