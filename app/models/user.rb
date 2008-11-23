class User < ActiveRecord::Base
  acts_as_authentic
  before_validation :generate_login_if_blank
  
  has_many :studies
  
  def should_be_shown_welcome_message?
    login_count == 1 && true
  end
  
  private
  
  def generate_login_if_blank
    return unless self.login.blank?
    self.login = self.email.split('@')[0]
  end
end