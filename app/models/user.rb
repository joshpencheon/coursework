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
  
  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end
  
  def watching?(study)
    watched_studies.include? study
  end

end