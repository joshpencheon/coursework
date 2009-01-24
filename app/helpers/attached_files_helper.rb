module AttachedFilesHelper
    
  def clickable_thumbnail_for(attached_file)
    options = if attached_file.displayable_inline?
      { :rel => (attached_file.plain_text? ? "facebox.formatted" : "facebox") }
    else
      { } 
    end

    if attached_file.thumbnailable?      
      link_to(image_tag(attached_file.document.url(:square), :class => 'bordered'),
        attached_file.document.url, options)
    else
      file = "#{attached_file.extension}.png"
      file = File.join('documents', 'square', file)
      file = "file.png" unless File.exists?(File.join(Rails.public_path, 'images', file))
      
      link_to(image_tag(file), attached_file.document.url, options)
    end
  end
  
  def file_size_for(attached_file)
    number_to_human_size(attached_file.document_file_size, :precision => 0)
  end
end
