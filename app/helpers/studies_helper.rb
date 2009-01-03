module StudiesHelper
  
  def text_for_watch_link(study)
    study.watched_by?(current_user) ? 'Stop watching this study' : 'Watch this study'    
  end
  
  def watch_link_for(study)
    sidebar_block('This Study') do
      content_tag :li, link_to(text_for_watch_link(study), watch_study_path(study), :class => 'watch_study_link')
    end
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
