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
end
