module NotificationsHelper
  def read_link(notification)
    text = notification.read? ? "Mark as unread" : "Mark as read"
    text += image_tag 'spinner.gif', :style => 'width: 10px;display:none'
    link_to text, read_notification_path(notification), :class => 'read_link'
  end
  
  def notification_div_for(notification, options = {}, &block)
    if notification.read?
      options[:class] ||= ''
      options[:class] += ' read'
    end
    
    div_for(notification, options, &block)
  end
  
  def event_title_for(event)
    user = event.news_item.user
    [ link_to(user.name, user), 'edited their', event.title ].join(' ')
  end
  
  def event_items_for(event)
    html = ''
    event.data.map do |pair|
      html << content_tag(:li, pair.values.first, :class => pair.keys.first)
    end
    content_tag :ul, html, :class => 'notification_items'
  end
end
