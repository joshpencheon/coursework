module StudiesHelper
  
  def text_for_watch_link(study)
    if study.watched_by?(current_user)
      text = 'You - Stop watching this study'
      style = {}
    else
      text = 'Watch this study'
      style = { :style => 'visibility: hidden' }
    end
    avatar_for(current_user, :minute, style) + text 
  end
  
  def watch_link_for(study)
    link_to(text_for_watch_link(study), watch_study_path(study), :class => 'watch_study_link watcher_link')
  end
  
  
  def saved_attachments_for(study)
    render(:partial => 'file', :collection => study.saved_attachments)
  end

  def unsaved_attachments_for(study)
    render(:partial => 'file', :collection => study.unsaved_attachments)
  end

  
  
  def fields_for_attachment(attachment, &block)
    prefix = attachment.new_record? ? 'new' : 'existing'
    fields_for("study[#{prefix}_attached_file_attributes][]", attachment, &block)
  end
  
  def errors_for_study(study)
    s.errors.reject { |key, value| key == 'attached_files' }
  end
   
  def errors_for_study_attachments(study)
    s.attached_files.map { |att| [att.id, att.errors] }
  end
  
end
