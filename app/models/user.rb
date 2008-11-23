class User < ActiveRecord::Base
  acts_as_authentic
  before_validation :generate_login_if_blank
  
  has_many :studies
  
  def name
    [first_name, last_name].reject(&:blank?).map(&:capitalize_name).join(' ')
  end
  
  
  private
  
  def generate_login_if_blank
    return unless self.login.blank?
    self.login = self.email.split('@', 2).first
  end
end