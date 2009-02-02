module TagHelper
  def tag_link_for(tag)
    link_to tag.name, :controller => 'studies', :action => 'tag', :id => tag
  end
end