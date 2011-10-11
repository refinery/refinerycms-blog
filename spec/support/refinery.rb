require 'refinerycms-testing'

Refinery::Testing.load_factories

RSpec.configure do |config|
  config.extend Refinery::Testing::ControllerMacros::Authentication, :type => :controller
  config.extend Refinery::Testing::RequestMacros::Authentication, :type => :request
end
