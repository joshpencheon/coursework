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
    user = event.news_item.user
    parts = [ user.name(:short), 'edited their', event.title.first, "'#{event.title.last}'" ]
    
    if true == options[:user_link] 
      parts.shift
      parts.unshift(link_to(user.name, user))
    end
    
    parts.join(' ')
  end
  
  def event_items_for(event)
    html = ''
    event.data.each_pair do |assoc, types|
      html << content_tag(:li, assoc.to_s.humanize, :class => 'section')
      
      if types.is_a?(Hash) 
        types.each_pair do |type, changes|
          if type.is_a?(Integer)
            instance = assoc.to_s.singularize.camelize.constantize.find(type)
            html << content_tag(:li, "#{instance.title}: #{changes}", :class => 'edited')          
          else
            klass = type == :new ? 'new' : 'deleted'
            html << content_tag(:li, changes, :class => klass )
          end
        end        
      else
        html << content_tag(:li, types, :class => 'edited')
      end
    end
    content_tag :ul, html, :class => 'notification_items'
  end
end
