require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should not be valid without login" do
    @user = User.new(:email => 'joe@bloggs.com', :password => 'secret', :password_confirmation => 'secret')
    @user.should_not be_valid
  end
  
  it "should not be valid without a valid-formed email address" do
    @user = User.new(:login => 'joe', :password => 'secret', :password_confirmation => 'secret')
    @user.should_not be_valid
    @user.email = 'com.bloggs@joe'
    @user.should_not be_valid
    @user.email = 'joe@bloggs.com'
    @user.should be_valid
  end

  context 'with login, email and password with confirmation' do
    before(:each) do
      @valid_attributes = { :login                 => 'joe',
                            :email                 => 'joe@bloggs.com',
                            :password              => 'secret',
                            :password_confirmation => 'secret' }
      @user = User.new( @valid_attributes )
    end
    
    def save_user_and_prepare_another_instance
      @user.save
      @another_user = User.new( @valid_attributes )      
    end
  
    it 'should be valid' do
      @user.should be_valid
    end
  
    context 'with login or email non-unique' do
      it 'should not be valid' do
        save_user_and_prepare_another_instance
        @another_user.should_not be_valid
        @another_user.login = 'joejoe'
        @another_user.should_not be_valid
      end
    end
    
    context 'with login and email unique' do
      it "should be valid" do
        save_user_and_prepare_another_instance
        @another_user.login = 'joejoe'
        @another_user.email = 'joe@bloggs.co.uk'
        @another_user.should be_valid
      end
    end
    
    context 'with only first name' do
      it 'should return it as full name' do
        @user = User.new(:first_name => 'Josh')
        @user.name.should == 'Josh'
      end
    end
    
    context 'with only last name' do
      it 'should return it as full name' do
        @user = User.new(:last_name => 'Pencheon')
        @user.name.should == 'Pencheon'
      end
    end
    
    context 'with both first name and last name' do
      it 'should return them both as full name' do
        @user = User.new(:first_name => 'josh', :last_name => 'pencheon')
        @user.name.should == 'josh pencheon'
      end
    end
    
  end
end