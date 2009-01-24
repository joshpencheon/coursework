class AttachedFile < ActiveRecord::Base
  belongs_to :study
  has_attached_file :document, 
                    :styles => { :square => [ '35x35', :png ] }  
                             
  attr_accessible :document, :notes
  validates_attachment_presence :document
  
  FILE_TYPES = {
    'jpg'     => 'JPEG image',
    'jpeg'    => 'JPEG image',
    'png'     => 'Portable Network Graphic',
    'gif'     => 'GIF image',
    'doc'     => 'Microsoft Word Document',
    'xls'     => 'Microsoft Excel Spreadsheet',
    'ppt'     => 'Microsoft PowerPoint Presentation',
    'numbers' => 'Apple Numbers Spreadsheet',
    'pages'   => 'Apple Numbers Spreadsheet',
    'key'     => 'Apple Keynote Presentation',
    'pdf'     => 'Adobe Portable Document Format',
    'txt'     => 'Plain Text Document'
  }
  
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
  
  def title
     document_file_name || 'untitled'
  end
  
  def plain_text?
    !! (document_content_type =~ %r(text/plain) || false)
  end
  
  def image?
    !! (document_content_type =~ /jpe?g|gif|bmp|png/ || false)
  end
  
  def hazard?
    !! (document_content_type =~ /zip/ || false)
  end
  
  def displayable_inline?
    plain_text? || image?
  end
  
  def thumbnailable?
    document_content_type =~ /pdf/ || image?
  end
  
  def file_string
    "#{FILE_TYPES[self.extension]} - " if FILE_TYPES[self.extension]
  end
  
  def untouched?
    new_record? && document_file_name.blank? && notes.blank?
  end

end
