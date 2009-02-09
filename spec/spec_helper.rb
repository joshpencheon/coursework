# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require 'rspec_rails_mocha'
require 'faker'
require File.expand_path(File.dirname(__FILE__) + '/foundries.rb')
require File.expand_path(File.dirname(__FILE__) + "/controller_macros")

Spec::Runner.configure do |config|

  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/yml'
  config.mock_with :mocha
  
  config.include(ControllerMacros, :type => :controller)
  config.include(RspecResponseEnhancer)
  
  config.before(:each) do  
    full_example_description = "#{self.class.description} #{@method_name}"  
    Rails::logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")  
  end
  
  def current_user(stubs = {})
    @current_user ||= User.with(stubs).valid.create!
  end

  def user_session(stubs = {}, user_stubs = {})
    @user_session ||= mock_model(UserSession, {:user => current_user(user_stubs)}.merge(stubs))
  end

  def login(session_stubs = {}, user_stubs = {})
    UserSession.stubs(:find).returns(user_session(session_stubs, user_stubs))
  end

  def logout
    @user_session = nil
  end
end