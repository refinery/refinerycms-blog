require 'rubygems'

def load_all(*patterns)
  patterns.each { |pattern| Dir[pattern].sort.each { |path| load File.expand_path(path) } }
end

def setup_environment  
  # Configure Rails Environment
  ENV["RAILS_ENV"] = 'test'
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
    
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'factory_girl_rails'
  
  Rails.backtrace_cleaner.remove_silencers!

  RSpec.configure do |config|
    config.mock_with :rspec
  end
end

def each_run  
  FactoryGirl.reload
  ActiveSupport::Dependencies.clear

  load_all 'spec/support/**/*.rb'
  load_all 'spec/factories/**/*.rb' if FactoryGirl.factories.none?
end

# If spork is available in the Gemfile it'll be used but we don't force it.
unless (begin; require 'spork'; rescue LoadError; nil end).nil?
  Spork.prefork { setup_environment }
  Spork.each_run { each_run }
else
  setup_environment
  each_run
end
