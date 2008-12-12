module UsersHelper

  def avatar_for(user, size = nil)
    image_tag user.avatar.url(size), :class => 'bordered avatar' 
  end

end
