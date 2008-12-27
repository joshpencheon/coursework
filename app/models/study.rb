class Study < ActiveRecord::Base
  belongs_to :user
  
  with_options :dependent => :destroy do |study|
    study.has_many :watchings
    study.has_many :attached_files
    study.has_many :events, :as => :news_item
  end
  
  has_many :watchers, :through => :watchings, :source => :user
  
  before_validation :remove_blank_attachments
  validates_presence_of :title, :description
  
  has_dirty_associations :attached_files, 
    :preload => false
  
  attr_writer :publish_event
  
  before_save :destroy_attached_files_marked_for_deletion  # must come before EventCreator
  before_save EventCreator.new, :if => Proc.new { |record| record.publish_event? }
  
  before_save do |study|
    changes = study.changes_by_type
    if !changes[:self] && changes.values.map(&:any?).any?
      study.updated_at = Time.now
    end
  end
  
  def publish_event
    @publish_event = true unless @publish_event == false 
    @publish_event
  end
  
  def publish_event?
    !!publish_event
  end
  
  def watched_by?(user)
    watchers.include? user
  end
  
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
        attributes.delete(:id) # Cannot be mass-assigned to.
        attachment.attributes = attributes
      else
        attachment.should_destroy = true
        # This destroy is taking place, and then the model is being reloaded,
        # So the event cannot be logged.
        #attached_files.destroy(attachment)
      end
    end
  end
  
  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-z]/,' ').strip.gsub(/\s/, '-')}"
  end
  
  private 
  
  def remove_blank_attachments
    attached_files.delete( attached_files.select(&:untouched?) )
  end
  
  def destroy_attached_files_marked_for_deletion
    attached_files.select(&:should_destroy?).each(&:delete)
  end
  
  def changes_for_serialization
    returning({}) do |serial|
      changes_by_type.each do |assoc, changeset|
        if assoc == :self
          serial[:self] = changeset
        else
          serial[assoc] = {}
          
          if changeset.key?(:new)
            serial[assoc][:new] = changeset[:new].map(&:id)
          end
          
          if changeset.key?(:edited)
            serial[assoc][:edited] = {}
            
            changeset[:edited].each_pair do |record, changes|
              serial[assoc][:edited][record.id] = changes
            end
          end
          
          if changeset.key?(:deleted)
            serial[assoc][:deleted] = changeset[:deleted].map(&:id)
          end
        end
      end
    end
  end
end
