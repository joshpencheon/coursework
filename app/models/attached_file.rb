class AttachedFile < ActiveRecord::Base
  ALLOWED_CONTENT_TYPES = {
    'MS Word'       => 'doc',
    'MS Excel'      => 'xls',
    'MS Powerpoint' => 'ppt',
    'Adobe PDF'     => 'pdf',
    'ZIP'           => 'zip',
    'JPEG'          => 'jpeg',
    'GIF'           => 'gif',
    'PNG'           => 'png',
    'text'          => 'txt'
  }
  APPLICATION_REGEXP = %r{^(x-)?application/#{ALLOWED_CONTENT_TYPES.values.join('|')}$}
  IMAGE_REGEXP = %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$}
  
  belongs_to :study
  has_attached_file :document, 
                    :styles => { :square => [ Proc.new { |instance| instance.send(:crop_geometry, '70x70#') }, :png ] },                    
                    :default_url => "/images/documents/:style/:extension.png"  
 
  attr_accessible :document, :should_destroy
  
  validates_attachment_presence :document
  validates_attachment_content_type :document, 
    :content_type => [ APPLICATION_REGEXP, IMAGE_REGEXP, 'text/plain' ],
    :message => "must be: #{ALLOWED_CONTENT_TYPES.values.map{|k| '.' + k }.join(' ')}"
  
  attr_accessor :should_destroy
  
  def should_destroy?
    !!self.should_destroy
  end
  
  def image?
    document_content_type =~ /jpe?g|gif|png/ || false
  end
  
  def hazard?
    document_content_type =~ /zip/ || false
  end
  
  def displayable_inline?
    document_content_type =~ %r(text/plain) || image?
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
