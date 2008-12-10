class Study < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :description
  
  before_validation :remove_blank_attachments
  has_many :attached_files, :dependent => :destroy
  
  has_many :events, :as => :news_item
  create_events :attached_files
  
  has_dirty_associations :attached_files
  
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
