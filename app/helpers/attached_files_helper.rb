module AttachedFilesHelper
    
  def clickable_thumbnail_for(attached_file)
    if attached_file.thumbnailable? 
      facebox_enabled_link_for(image_tag(attached_file.document.url(:square), :class => 'bordered'),
        attached_file)
    else
      file = "#{attached_file.extension}.png"
      file = File.join('documents', 'square', file)
      file = "file.png" unless File.exists?(File.join(Rails.public_path, 'images', file))
      
      facebox_enabled_link_for image_tag(file), attached_file
    end
  end
  
  def facebox_enabled_link_for(text, attached_file, options = {})      
    if attached_file.displayable_inline?
      options[:rel] = "facebox"
      options[:rel] += ".formatted" if attached_file.plain_text?
    end
    
    link_to(text, attached_file.document.url, options)
  end
  
  def file_size_for(attached_file)
    number_to_human_size(attached_file.document_file_size, :precision => 0)
  end
end
