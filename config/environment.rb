# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_resource ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3" 
  config.gem :authlogic, :version => '>=1.3.0'
  config.gem :paperclip
  
  # Gems required for testing
  config.gem :ZenTest
  config.gem :mocha
  # RSpec should will load itself when tests are run
  # config.gem 'rspec-rails', :lib => 'spec/rails'
  # config.gem 'rspec', :lib => 'spec'

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_coursework_session',
    :secret      => '639b3cc326561b522be214d549c3f35f80e90284391ee43137582afdc9f0aa0ff90de21ecfda48622f70a29dfd19027f3dce1f96b25f3f1b3c6d8b1192bf44ee'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end

require 'class_extensions'

# Replace <div> tags with <span> tags, as the form field will already be wrapped in a block element.
ActionView::Base.field_error_proc = 
  Proc.new{ |html_tag, instance| "<span class=\"field_with_errors\">#{html_tag}</span>" }
  
# A field now follows a corresponding label, and it is all wrapped in a paragraph tag.
# if the :no_label option evaluates to true, the field reverts to the default FormBuilder.
ActionView::Base.default_form_builder = ::ActionView::Helpers::LabellingFormBuilder

# Paperclip needs to know where ImageMagick's +identity+ command is:
Paperclip.options[:image_magick_path] = '/opt/local/bin'