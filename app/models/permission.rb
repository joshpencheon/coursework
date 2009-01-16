class Permission < ActiveRecord::Base
  with_options :class_name => 'User' do |permission|
    permission.belongs_to :requester
    permission.belongs_to :requestee
  end
  
  named_scope :granted,  :conditions => { :granted => true }
  named_scope :declined, :conditions => { :granted => false, :read => true }
  named_scope :pending,  :conditions => { :read => false }
  
  validates_length_of :message, :maximum => 255, 
    :message => "cannot be longer than {{count}} charachters", 
    :unless => proc { |instance| instance.message.blank? }
  
  attr_protected :granted
  
  def grant
    set(true)
  end
  
  def reject
    set(false)
  end
  alias_method :revoke, :reject
  
  def set(bool)
    update_attribute :granted, bool
    update_attribute :read, true
  end
  
end
