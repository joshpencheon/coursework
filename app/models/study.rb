class Study < ActiveRecord::Base
  CATEGORIES = %w( Energy Travel Procurement ).freeze
  
  belongs_to :user
  belongs_to :region
  belongs_to :partnership
  
  with_options :dependent => :destroy do |study|
    study.has_many :watchings
    study.has_many :attached_files
    study.has_many :comments
    study.has_many :events, :as => :news_item
  end
  
  has_many :watchers, :through => :watchings, :source => :user
  
  before_validation :remove_blank_attachments
  validates_presence_of :title, :description
  
  validates_presence_of  :category, :partnership_id, :region_id,
    :message => "needs to be selected"
    
  validates_inclusion_of :category, :in => CATEGORIES, :message => 'needs to be a category'

  attr_writer :publish_event
  
  before_save StudyEvent.new, 
    :if => Proc.new { |study| study.publish_event? && !study.new_record? }
    
  after_save do |study|
    study.attached_files.select(&:changed?).map(&:save)
  end
  
  def publish_event
    @publish_event != false ? @publish_event = true : @publish_event
  end
  
  def watchers_other_than(array)
    watchers - [ array ].flatten
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
    attached_files.select(&:new_record?)
  end
  
  def new_attached_file_attributes=(attached_file_attributes)
    attached_file_attributes.each do |attributes|
      attached_files.build(attributes)
    end
  end
  
  def existing_attached_file_attributes=(attached_file_attributes)
    attached_files.reject(&:new_record?).each do |attached_file|
      attributes = attached_file_attributes[attached_file.id.to_s]
      if attributes
        attached_file.attributes = attributes
      else
        attached_file.destroy
      end
    end
  end
  
  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-z]/,' ').strip.gsub(/\s{1,}/, '-')}"
  end
  
  private 
  
  def remove_blank_attachments
    attached_files.delete( attached_files.select(&:untouched?) )
  end
end
