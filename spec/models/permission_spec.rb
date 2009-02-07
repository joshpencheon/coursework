require File.dirname(__FILE__) + '/../spec_helper'

describe Permission do
  before(:each) do
    @requester, @requestee = User.valid.create!, User.valid.create!
    @permission = @requester.sent_requests.build({:requestee_id => @requestee.id})
  end
  
  context 'before being sent' do
    [ # Value    Valid
      [ nil,     true  ],
      [ '',      true  ],
      [ 'a'*255, true  ],
      [ 'a'*256, false ]
    ].each do |test_message, result|
      it 'should have its validity affected by message length' do
        @permission.message = test_message if test_message
        @permission.valid?.should equal(result)
      end      
    end
    
    it 'should protect the #granted attribute' do
      @permission.update_attributes!({:granted => true})
      @permission.reload.should_not be_granted
    end
  end
  
  context 'once saved' do
    before(:each) do
      @permission.save!
    end
    
    [ # Method    Read    Granted
      [ :grant,   true,   true  ],
      [ :reject,  true,   false ],
      [ :revoke,  true,   false ]
    ].each do |method, read, granted|
      it "should set read=#{read}, granted=#{granted} when sent ##{method}" do
        @permission.send(method)
        @permission.reload
        @permission.read?.should equal(read)
        @permission.granted?.should equal(granted)
      end
    end
  end
  
end