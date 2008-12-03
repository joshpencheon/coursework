class Study < ActiveRecord::Base
  validates_presence_of :title, :description
  
  has_many :attached_files, :dependent => :destroy
  belongs_to :user
  
  def saved_attachments
    @saved_attachments ||= attached_files.reject(&:new_record?)
  end
  
  # Effectively returns all attachments that haven't 
  # made it to the database, plus another new instance.
  def unsaved_attachments
    returning attached_files - saved_attachments do |unsaved|
      unsaved << attached_files.build unless unsaved.detect(&:untouched?)
    end 
    # untouched, unsaved = (attached_files - saved_attachments).partition(&:untouched?)
    # untouched = [untouched.any? ? untouched.first : attached_files.build] # Only need one.
    # unsaved.any? ? unsaved + untouched : untouched
  end
  
  def new_attached_file_attributes=(attached_file_attributes)
    attached_file_attributes.each do |attributes|
      attached_files.build(attributes)
    end
  end
  
  def existing_attached_file_attibutes=(attached_file_attributes)
    saved_attachments.each do |attachment|
      attributes = attached_file_attributes[attachment.id.to_s]
      if attributes
        attachment.attributes = attributes
      else
        attached_files.delete(attachment)
      end
    end
  end
  
end
