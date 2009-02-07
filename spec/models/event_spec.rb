require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  context 'freshly initialized' do
    it 'should raise an error if saved' do
      proc { Event.create! }.should raise_error
    end
  end
  
  context 'with an assigned news item' do
    it 'should save successfully' do
      proc { @event = Event.valid.create! }.should_not raise_error
      @event.should_not be_new_record
    end
    
    context 'once saved from a news item with watchers' do
      before(:each) do
        @user  = User.valid.create!
        @event = Event.valid.build
        Watching.toggle(@event.news_item, @user)
      end
      
      it 'should have generated notifications for all of the watchers' do
        proc { @event.save! }.should change(@user, :notification_count).by(1)
      end
    end
  end
end