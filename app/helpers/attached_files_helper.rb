module AttachedFilesHelper
  def clickable_thumbnail_for(attached_file)
    path = if attached_file.thumbnailable?
      attached_file.document.url(:square)
    else
      file = "#{attached_file.extension}.png"
      file = File.join('documents', 'square', file)
      file = "file.png" unless File.exists?(File.join(Rails.public_path, 'images', file))
      file
    end
    if attached_file.displayable_inline? 
      options = { :rel => (attached_file.plain_text? ? "facebox.formatted" : "facebox") }
    end
    
    link_to image_tag(path, :class => 'bordered'), attached_file.document.url, options || {}
  end

end
