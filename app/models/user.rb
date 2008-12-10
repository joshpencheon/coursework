class User < ActiveRecord::Base
  acts_as_authentic
  
  has_attached_file :avatar, :styles => { :tiny => '20x20', :original => '70x70' }
  attr_protected :avatar_content_type, :avatar_file_name, :avatar_size
  
  has_many :studies, :dependent => :destroy
  
  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

end