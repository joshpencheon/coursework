module StudiesHelper
  
  def watch_link_for(study)
    options = if study.watched_by? current_user
      [ 'Stop watching this study', unwatch_study_path(@study) ]
    else
      [ 'Watch this study', watch_study_path(@study) ]
    end
    options << { :id => 'watch_study_link'}
    
    sidebar_action(*options)
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
