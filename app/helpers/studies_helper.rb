module StudiesHelper
  
  def saved_attachments_for(study)
    render(:partial => 'file', :collection => study.saved_attachments)
  end

  def new_attachments_for(study)
    render(:partial => "file", :collection => study.unsaved_attachments)
  end
  
  def fields_for_attachment(attachment, &block)
    prefix = attachment.new_record? ? 'new' : 'existing'
    fields_for("study[#{prefix}_attached_file_attributes][]", attachment, &block)
  end

end
