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
  
  # attr_accessor :attached_files_traversed
  # attr_protected :attached_files_traversed
  
 # before_save :manage_attached_files  # must come before EventCreator
  before_save :remove_blank_attachments
  before_save EventCreator.new, :if => Proc.new { |record| record.publish_event? }
  before_save :update_timestamp_from_associations
  
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
  # 
  def unsaved_attachments
    attached_files - saved_attachments
  end
  # 
  def new_attached_file_attributes=(attached_file_attributes)
    attached_file_attributes.each do |attributes|
      attached_files.build(attributes)
    end
  end
  # 
  # def existing_attached_file_attributes=(attached_file_attributes)
  #   saved_attachments.each do |attachment|
  #     attributes = attached_file_attributes[attachment.id.to_s]
  #     if attributes
  #       attributes.delete(:id) # Cannot be mass-assigned to.
  #       attachment.attributes = attributes
  #     else
  #       attachment.should_destroy = true
  #     end
  #   end
  #   @attached_files_traversed = true
  # end
  
  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-z]/,' ').strip.gsub(/\s/, '-')}"
  end
  
  private 
  
  def update_timestamp_from_associations
    self.updated_at = Time.now if self.changes_by_type.values.any?
  end
  
  def remove_blank_attachments
    attached_files.delete( attached_files.select(&:untouched?) )
  end
  
  def manage_attached_files
    attached_files.select(&:should_destroy).each(&:delete)
    unsaved_attachments.each(&:save)
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
