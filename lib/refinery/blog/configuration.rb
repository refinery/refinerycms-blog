module Refinery
  module Blog
    include ActiveSupport::Configurable

    config_accessor :mount_path

    def self.default_settings!
      self.mount_path = "/blog"
    end

    default_settings!
  end
end
