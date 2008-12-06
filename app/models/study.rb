class Study < ActiveRecord::Base
  validates_presence_of :title, :description
  
  before_validation :remove_blank_attachments
  
  has_many :attached_files, :dependent => :destroy
  belongs_to :user
  
  def saved_attachments
    @saved_attachments ||= attached_files.reject(&:new_record?)
  end

  def unsaved_attachments
    attached_files - saved_attachments
  end
  
  def new_attached_file_attributes=(attached_file_attributes)
    attached_file_attributes.each do |attributes|
      attached_files.build(attributes)
    end
  end
  
  def existing_attached_file_attributes=(attached_file_attributes)
    saved_attachments.each do |attachment|
      attributes = attached_file_attributes[attachment.id.to_s]
      if attributes
        logger.info(
        "UPDATING ##{attachment.id.to_s}: #{attributes.inspect}"
        )
        attachment.attributes = attributes
      else
        attached_files.delete(attachment)
      end
    end
  end
  
  private 
  
  def remove_blank_attachments
    attached_files.delete( attached_files.select(&:untouched?) )
  end
end
