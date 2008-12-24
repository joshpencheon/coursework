class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  named_scope :read,   :conditions => { :read => true }
  named_scope :unread, :conditions => { :read => false }
  named_scope :most_recent_first, :order => 'created_at DESC'
  
  default_scope :include => [ :event, :user ]
  
  def self.build_from_events(events)
    if events.is_a?(Array)
      events.map { |e| build_from_events(e) }
    else
      new(:event_id => events.id)
    end
  end
  
  def read!
    update_attribute(:read, true)
  end

end
