class AttachedFile < ActiveRecord::Base
  belongs_to :study
  has_attached_file :document, 
                    :styles => { :square => [ Proc.new { |instance| instance.send(:crop_geometry) }, :png ] }  
  
  before_destroy do |instance|
    instance.study.events.create(:title => '1 attached file was removed from the study.', :data => [])
  end
                             
  attr_accessible :document
  
  validates_attachment_presence :document
  
  
  def icon_path
    path = "file_#{extension}.png"
    if File.exists?(File.join(Rails.public_path, 'images', 'icons', path))
      path
    else
      "file.png"
    end
  end
  
  def extension
    ext = File.extname(self.document_file_name).gsub(/\./, '')
    ext.chop! if ext[-1,1] == 'x'
    ext = 'jpeg' if ext == 'jpg'    
    ext
  end
  
  def plain_text?
    document_content_type =~ %r(text/plain) || false
  end
  
  def image?
    document_content_type =~ /jpe?g|gif|bmp|png/ || false
  end
  
  def hazard?
    document_content_type =~ /zip/ || false
  end
  
  def displayable_inline?
    plain_text? || image?
  end
  
  def thumbnailable?
    document_content_type =~ /pdf/ || image?
  end
  
  def untouched?
    return false unless new_record?
    (attributes == self.class.new.attributes) ||
      (attributes == study.attached_files.build.attributes) rescue false
  end
  
  private
  
  # using the '#' (crop) custom geometry-string modifier with
  # multi-page PDFs doesn't work. This removes the crop option 
  # for PDFs. (Paperclip still wants to thumbnail, but its not
  # an image.)
  def crop_geometry(string)
    string.chop! if string[-1,1] == '#' && !image?
    string
  end

end
