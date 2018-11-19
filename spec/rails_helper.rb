# This file is copied to spec/ when you run 'rails generate rspec:install'
# Modified for TransAM engines

ENV['RAILS_ENV'] ||= 'test'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'simplecov'
SimpleCov.start 'rails' do
  add_group "Jobs", "app/jobs"
  add_group "Reports", "app/reports"
  add_group "Services", "app/services"
  add_group "Searches", "app/searches"
end

require 'spec_helper'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner'
require 'shoulda-matchers'
require 'devise'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[TransamEngine::Engine.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, :type => :controller

  config.color = true                  # Use color in STDOUT
  config.tty = true                    # Use color not only in STDOUT but also in pagers and files
  config.formatter = :documentation    # Use the specified formatter
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    with.library :rails
  end
end
