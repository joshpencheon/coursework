class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :studies, :dependent => :destroy
  
  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

end