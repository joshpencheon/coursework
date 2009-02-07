require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  context 'with valid attributes' do
    before(:each) do
      @user = User.valid.new
    end
    
    [:login, :email].each do |attr|
      context "except a non-unique #{attr}" do
        it "should not be valid" do
          options = { attr => 'joe@bloggs.com' }
          User.with(options).valid.create!
          lambda { @user.update_attributes!(options) }.should raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
    
    it 'should be valid' do
      @user.should be_valid
    end
  end
  
  context 'when freshly initialized and then saved' do    
    before(:each) do
      @user = User.valid.new
    end
    
    it 'should not be possible to update #admin' do
      @user.update_attributes!({:admin => true})
      @user.should_not be_admin
    end
    
    it 'the secure hex token should over-write anything already assigned' do
      @user.token = 'hehehe'
      @user.token.should_not be_nil
      @user.save!
      @user.token.length.should == 32 # 16-digit in hex
    end
  end
  
  context 'when assigning an avatar' do
    before(:each) do
      @user = User.valid.new
    end
    
    attrs  = [:avatar_content_type, :avatar_file_name, :avatar_file_size]
    values = ['something/harmless', 'completely fine', 'remarkably tiny']
    
    attrs.zip(values).each do |pair|
      attr, value = *pair
      
      it "should not assign to '#{attr}' by other ways" do
        @user.update_attributes({attr => value})
        @user.send(attr).should_not == value
        
        @user.send("#{attr}=", value)
        @user.send(attr).should == value
      end
    end
  end
  
  context 'with a first name' do
    before(:each) do
      @user = User.new(:first_name => 'josh')
    end
    
    it 'should return it as shortened name' do
      @user.name(:short).should == 'Josh'
    end
    
    context 'and no last name' do
      it 'should return their first name as #full_name' do
        @user.name.should == 'Josh'
      end
    end
    
    context 'and last name' do
      it 'should return them both as full name' do
        @user.last_name = 'pencheon'
        @user.name.should == 'Josh Pencheon'
      end
    end
  end
  
  context 'without a first name' do
    before(:each) do
      @user = User.new(:login => 'jpencheon')
    end
    
    context 'but a last name' do
      it 'should return it as #full_name' do
        @user.last_name = 'pencheon'
        @user.name.should == 'Pencheon'        
      end
    end
    
    context 'or a last name' do
      it 'should return login as name' do
        @user.name.should == 'jpencheon'
      end

      it 'should return login as shortened name' do
        @user.name(:short).should == 'jpencheon'
      end
    end
  end
  
  context 'that has been saved' do
    before(:each) do
      @user = User.valid.create!
    end
    
    it 'should not be able to change the secure hex token' do
      @user.update_attributes!({:token => 'easy_to_remember'})
      @user.reload.token.should_not == 'easy_to_remember'
    end
    
    context 'who is watching a study' do
      before(:each) do
        @study = Study.valid.create!
        @user  = User.valid.create!      
        Watching.toggle(@study, @user)
      end

      it 'should => true for #watching? when called with the study in question' do
        @user.watching?(@study).should be_true
      end

      it 'should => false for #watching? when called with another study' do
        @user.watching?(Study.valid.create!).should be_false
      end
      
      context 'and an event is created' do
        before(:each) do
          @action = proc { @study.update_attributes!({:title => 'a different title.'}) }
        end
        
        it 'should receive an notification of that event' do
          @action.should change(@user, :notification_count).by(1)          
        end
        
        it 'should have #unread_notifications?' do
          @action.should change(@user, :has_unread_notifications?).from(false).to(true)
        end
      end
    end
    
    context 'when communicating with other users' do
      context 'and sending requests' do
        it 'should list requestees through requests they have made' do
          requestees = []
          5.times do |i|
            requestees << User.valid.create!
            @user.sent_requests.create!({:granted => false, :requestee_id => requestees.last.id})
          end

          @user.sent_requests.length.should == 5  
          @user.requestees.map(&:id).should =~ requestees.map(&:id)
        end

        it 'should know whether it has sent a request to a particular user' do
          another_user = User.valid.create!
          @user.sent_requests.create!({:granted => false, :requestee_id => another_user.id})      
          @user.has_sent_request_to?(another_user).should be_true
        end  
      end
            
      context 'and receiving requests' do
        it 'should increment notifications count' do
          proc { @user.received_requests.create! }.should change(@user, :notification_count).by(1)
        end
        
        it 'should sum pending requests with notifications count' do
          @user.received_requests.create!
          2.times { @user.notifications.create!(:read => false) }
          @user.notification_count.should == 3
        end
        
        it 'should list requesters through the requests that have been made' do
          requesters = []
          5.times do |i|
            requesters << User.valid.create!
            requesters.last.sent_requests.create!({:granted => false, :requestee_id => @user.id})
          end

          @user.received_requests.length.should == 5  
          @user.requesters.map(&:id).should =~ requesters.map(&:id)          
        end
        
        it 'should know whether it has received a request from a particular user' do
          another_user = User.valid.create!
          another_user.sent_requests.create!({:granted => false, :requestee_id => @user.id})      
          @user.find_request_from(another_user).should_not be_nil          
        end
        
        context 'which are then acted upon' do
          before(:each) do
            @requester = User.valid.create!
            @requester.sent_requests.create!({:granted => false, :requestee_id => @user.id})
            @request = @user.find_request_from(@requester)
          end
          
          it 'should add the requester to their disciples (whitelist) if the request is granted' do
            proc { @request.grant }.should change(@user, :disciples).from([]).to([@requester])
          end
          
          [:revoke, :reject].each do |meth|
            it "should add the requester to their blacklist if the request is sent ##{meth} (alias)" do
              proc { @request.send(meth) }.should change(@user, :blacklist).from([]).to([@requester])
            end
          end
        end
      end
    end
    
    context 'when formatted for URLs' do
      before(:each) do
        @user.id = 4
      end
      
      it 'should combine id and login' do
        @user.login = 'josh'
        @user.to_param.should == '4-josh'
      end
      
      it 'should convert their login to lower case' do
        @user.login = 'Roger Rabbit'
        @user.to_param.should == '4-roger-rabbit'
      end
      
      it 'should remove illegal characters from the login' do
        @user.login = "Roger O'Reilly"
        @user.to_param.should == '4-roger-o-reilly'
      end
    end
  end
  
  context 'having edited studies' do
    before(:each) do
      @user = User.valid.create!
      @study = @user.studies.valid.create!
      10.times do |i|
        @study.update_attributes!({:title => "study_#{i}"})
      end
    end
    
    it 'should have generated the corresponding events' do
      @study.events.length.should == 10
    end
    
    context 'when listing events' do
      it 'should only list relevant events' do
        @user.recent_events.each do |event|
          event.news_item.user.should == @user
        end
      end
      
      [ 1 , 5 , 11 ].each do |n|
        it "should list the last #{n}" do
          recent_events = @user.recent_events(n)
          recent_events.length.should <= n
        end
      end      
    end
  end
end