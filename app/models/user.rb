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
  end
  
  has_many :watched_studies, :through => :watchings, :source => :study
  
  def admin?
    true
  end
  
  def name(version = :long)
    parts = [first_name, last_name]
    
    if version == :short
      parts.first.blank?   ? self.login : parts.first
    else
      parts.reject(&:blank?).join(' ')
    end
  end
  
  def watching?(study)
    watched_studies.include? study
  end
  
  def has_unread_notifications?
    !notifications.unread.count.zero?
  end
  
  def recent_events(limit = 5)
    studies.map(&:events).flatten.sort {|a, b| b.created_at <=> a.created_at }.slice(0...limit)
  end
  
  def to_param
    "#{id}-#{login.downcase.gsub(/[^a-z]/,' ').strip.gsub(/\s/, '-')}"
  end

end