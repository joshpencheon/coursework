module UsersHelper

  def avatar_for(user, size = nil)
    klass = 'avatar bordered'
    klass += "_#{size}" if size
    image_tag user.avatar.url(size), :class => klass
  end
  
  def request_link_for(user)
    if current_user.has_sent_request_to(user)
      'request sent'
    else
      link_to 'request', request_permission_path(user) 
    end
  end
  
end
