require File.dirname(__FILE__) + '/../spec_helper'

describe Notification do
  context 'when initialising from events' do 
    [1, 2].each do |n|
      it 'should build notifications for each event passed if multiple events are' do
        events = []; n.times { events << Event.valid.create! }
      
        notifications = Notification.build_from_events(events)
        notifications.length.should == n
        notifications.all? { |notification|
          notification.is_a?(Notification) && notification.new_record?
        }.should be_true
      end
    end
  end
  
  context 'when sent #read!' do
    it 'should update its #read attribute to be true' do
      @notification = Notification.create!
      @notification.read!
      @notification.reload.should be_read
    end
  end
end