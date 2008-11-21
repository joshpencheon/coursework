class User < ActiveRecord::Base
  acts_as_authentic
  before_validation :generate_login_if_blank
  
  has_many :studies
  
  private
  
  def generate_login_if_blank
    return unless self.login.blank?
    self.login = self.email.split('@')[0]
  end
end