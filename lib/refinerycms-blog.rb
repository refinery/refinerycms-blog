require 'filters_spam'
require File.expand_path('../generators/blog_generator', __FILE__)

module Refinery
  module Blog
    autoload :Version, File.expand_path('../refinery/blog/version', __FILE__)
    autoload :Tab, File.expand_path("../refinery/blog/tabs", __FILE__)

    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end

      def version
        ::Refinery::Blog::Version.to_s
      end
    end

    class Engine < Rails::Engine
      config.to_prepare do
        require File.expand_path('../refinery/blog/tabs', __FILE__)
      end

      initializer "init plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_blog"
          plugin.url = app.routes.url_helpers.refinery_admin_blog_posts_path
          plugin.menu_match = /^\/refinery\/blog\/?(posts|comments|categories)?/
          plugin.activity = {
            :class => Refinery::BlogPost
          }
        end
      end
    end if defined?(Rails::Engine)
  end
end
