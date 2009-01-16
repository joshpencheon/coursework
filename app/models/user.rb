class User < ActiveRecord::Base
  acts_as_authentic
  
  has_attached_file :avatar, 
                    :styles => { :original => "70x70#",
                                 :tiny => "30x30#" },
                    :default_url => '/images/avatars/:style_missing.png'

  attr_accessor :destroy_avatar  
  attr_protected :avatar_content_type, :avatar_file_name, :avatar_size
  
  with_options :dependent => :destroy do |user|
    user.has_many :studies
    user.has_many :watchings
    user.has_many :notifications
    
    user.with_options :class_name => 'Permission' do |u|
      u.has_many :received_requests, :foreign_key => 'requestee_id'
      u.has_many :sent_requests,     :foreign_key => 'requester_id'
    end
  end
  
  has_many :events
  has_many :requesters, :through => :received_requests
  has_many :requestees, :through => :sent_requests
  
  has_many :watched_studies, :through => :watchings, :source => :study
  
  def disciples
    requesters.find(received_requests.granted.map(&:requester_id))
  end
  
  def admin?
    true
  end
  
  def name(version = :long)
    parts = [first_name, last_name]
    
    string = version == :short ?
      parts.first : parts.reject(&:blank?).join(' ')
    
    string.blank? ? login : string.capitalize_name
  end
  
  def watching?(study)
    watched_studies.include? study
  end
  
  def find_request_from(requestee_id)
    received_requests.find_by_requestee_id(requestee_id)    
  end
  
  def has_sent_request_to(requestee_id)
    !!sent_requests.find_by_requestee_id(requestee_id)    
  end
  
  def has_unread_notifications?
    !notification_count.zero?
  end
  
  def notification_count
    notifications.unread.count + received_requests.pending.count
  end
  
  def recent_events(limit = 5)
    studies.map(&:events).flatten.sort { |a, b| 
      b.created_at <=> a.created_at }.slice(0...limit)
  end
  
  def to_param
    "#{id}-#{login.downcase.gsub(/[^a-z]/,' ').strip.gsub(/\s/, '-')}"
  end

end