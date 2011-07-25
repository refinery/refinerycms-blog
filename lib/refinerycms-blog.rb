require 'filters_spam'

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
      initializer 'blog serves assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.to_prepare do
        require File.expand_path('../refinery/blog/tabs', __FILE__)
      end

      config.after_initialize do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_blog"
          plugin.url = {:controller => '/admin/blog/posts', :action => 'index'}
          plugin.menu_match = /^\/?(admin|refinery)\/blog\/?(posts|comments|categories)?/
          plugin.activity = {
            :class => BlogPost
          }
        end
      end
    end if defined?(Rails::Engine)
  end
end
