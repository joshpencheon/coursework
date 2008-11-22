require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_valid_user_is_valid
    assert_valid(valid_user)
  end
  
  def test_user_requires_valid_email_password_and_confirmation
    @user = User.new :email => 'joe@bloggs.com', :password => 'secret', :password_confirmation => 'secret'
    errors = [:email, :password, :password_confirmation].map {|attr| @user.errors.on(attr) }
    assert !errors.all?
  end
  
  def test_email_is_of_suitable_form
    @user = valid_user
    @user.email = valid_user.email.reverse
    assert_errors_on(@user, :email)
  end
   
  def test_user_must_have_unqiue_login_and_email
    valid_user.save
    @user = valid_user
    assert_errors_on(@user, :email, :login)
    @user.login = valid_user.login.reverse
    assert_errors_on(@user, :email)
    assert_no_errors_on(@user, :login)
    @user.email = valid_user.email.sub(/com/,'co.uk')
    assert_valid(@user)
  end
  
  def test_login_auto_generated_if_blank
    @user = User.new :login => nil, :email => 'joe@bloggs.com'
    @user.valid? #Force validation
    assert @user.login, 'joe'
  end
  
  def test_login_not_auto_generated_if_not_blank
    @user = User.new :login => 'joe123', :email => 'joe@bloggs.com'
    @user.valid?
    assert @user.login, 'joe123'
  end
  
  private 
  
  def valid_user
    User.new(:login                 => 'joe',
             :email                 => 'joe@bloggs.com',
             :password              => 'secret',
             :password_confirmation => 'secret' )
  end
end
