require 'refinerycms-core'
require 'refinerycms-settings'
require 'filters_spam'
require 'rails_autolink'
require 'friendly_id'

module Refinery
  autoload :BlogGenerator, 'generators/refinery/blog/blog_generator'

  module Blog
    require 'refinery/blog/engine'
    require 'refinery/blog/configuration'

    autoload :Version, 'refinery/blog/version'
    autoload :Tab, 'refinery/blog/tabs'

    class << self
      attr_writer :root
      attr_writer :tabs

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def tabs
        @tabs ||= []
      end

      def version
        ::Refinery::Blog::Version.to_s
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end
