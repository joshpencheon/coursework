module AttachedFilesHelper
  def thumbnail_for(attached_file)
    path = if attached_file.thumbnailable?
      attached_file.document.url(:square)
    else
      file = "#{attached_file.extension}.png"
      unless File.exists?(File.join(Rails.public_path, 'images/documents/square', file))
        file = "file.png"
      end
      "/images/documents/square/#{file}"
    end
    image_tag path, :class => 'bordered'
  end

end
