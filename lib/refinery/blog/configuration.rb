module Refinery
  module Blog
    include ActiveSupport::Configurable

    config_accessor :mount_path

    self.mount_path = "/blog"
  end
end
