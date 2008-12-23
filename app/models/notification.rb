class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  named_scope :read,   :conditions => { :read => true }
  named_scope :unread, :conditions => { :read => false }
  named_scope :most_recent_first, :order => 'created_at DESC'
  
  def read!
    update_attribute(:read, true)
  end

end
