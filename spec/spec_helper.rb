require 'rubygems'

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)
require File.expand_path("../support/refinery_blog_test_user", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
end

# set javascript driver for capybara
require "selenium/webdriver"

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--no-sandbox'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--window-size=1440,1080'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.javascript_driver = (ENV['CAPYBARA_DRIVER'] || :selenium_chrome_headless).to_sym

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories including factories.
([Rails.root.to_s] | ::Refinery::Plugins.registered.pathnames).map{|p|
  Dir[File.join(p, 'spec', 'support', '**', '*.rb').to_s]
}.flatten.sort.each do |support_file|
  require support_file
end
