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
  APPLICATION_REGEXP = %r{^(x-)?application/x-png|jpg|pjpeg|#{ALLOWED_CONTENT_TYPES.values.join('|')}$}
  IMAGE_REGEXP = %r{^image/(x-png|pjpeg|jpeg|jpg|png|gif)}
  
  belongs_to :study
  has_attached_file :document
  
  # Temp.
  before_validation :validate_document
  
  validates_attachment_presence :document
  validates_attachment_content_type :document, 
    :content_type => [ APPLICATION_REGEXP, IMAGE_REGEXP, 'text/plain' ],
    :message => "must be: #{ALLOWED_CONTENT_TYPES.values.map{|k| '.' + k }.join(' ')}"
  
  def image?
    document_content_type =~ /jpeg|gif|png/
  end
  
  def hazard?
    document_content_type =~ /zip/
  end
  
  def displayable_inline?
    image? || document_content_type =~ %r(text/plain)
  end
  
  def untouched?
    return false unless new_record?
    reference = study.attached_files.build
    attributes.all? {|attr, value| value == reference.send(attr)}
  end
  
  private
  
  # Hopefully only a temporary fix until Paperclip 2.1.4 is released as a gem.
  def validate_document
    document.send(:validate)
  end
end