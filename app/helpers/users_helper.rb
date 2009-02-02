module UsersHelper

  def avatar_for(user, size = nil, options = {})
    klass = options.delete(:class) || ''
    klass += 'avatar bordered'
    klass += "_#{size}" if size
    image_tag user.avatar.url(size), options.merge({:class => klass})
  end
  
  def watcher_link_for(user, extra_text = '')
    text = avatar_for(user, :minute) + user.name
    link_to text + extra_text, user, :class => 'watcher_link'
  end
  
end
