module UsersHelper

  def avatar_for(user, size = nil)
    klass = 'avatar bordered'
    klass += "_#{size}" if size
    image_tag user.avatar.url(size), :class => klass
  end

end
