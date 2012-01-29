module Refinery
  module Blog
    include ActiveSupport::Configurable

    config_accessor :validate_source_url

    self.validate_source_url = false
  end
end