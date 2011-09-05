require 'rubygems'

def setup_environment
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # Configure Rails Environment
  ENV["RAILS_ENV"] = 'test'
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
    
  require 'rspec/rails'
  require 'capybara/rspec'
  
  Rails.backtrace_cleaner.remove_silencers!

  RSpec.configure do |config|
    config.mock_with :rspec
  end
end

def each_run  
  require 'factory_girl_rails'
  require 'refinerycms-testing'
  
  Dir[File.expand_path("../../app/models/**/*.rb", __FILE__)].each do |model|
    load model
  end
  
  Dir[
    File.expand_path("../support/**/*.rb", __FILE__),
    File.expand_path("../factories/**/*.rb", __FILE__)
  ].each {|f| require f}
end

# If spork is available in the Gemfile it'll be used but we don't force it.
unless (begin; require 'spork'; rescue LoadError; nil end).nil?
  Spork.prefork do
    setup_environment
    
    ActiveSupport::Dependencies.clear
  end

  Spork.each_run do
    each_run
  end
else
  setup_environment
  each_run
end
