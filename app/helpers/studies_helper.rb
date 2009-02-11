module StudiesHelper
  
  def category_image_for(study)
    link_to image_tag("/images/#{study.category}.png", :class => 'category'),
      search_studies_path(:category => study.category)
  end
  
  def text_for_watch_link(study)
    style = {}
    if study.watched_by?(current_user)
      text = 'You - <span class="underline">Stop watching</span>'
    else
      text = 'Watch this study'
      style[:style] = 'visibility: hidden'
    end
    avatar_for(current_user, :minute, style) + text 
  end
  
  def watch_link_for(study)
    link_to(text_for_watch_link(study), watch_study_path(study), :class => 'watch_study_link watcher_link')
  end  
  
  def fields_for_attachment(attachment, &block)
    prefix = attachment.new_record? ? 'new' : 'existing'
    fields_for("study[#{prefix}_attached_file_attributes][]", attachment, &block)
  end
  
end
