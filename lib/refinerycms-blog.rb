require 'filters_spam'

module Refinery
  module Blog
    autoload :Version, File.expand_path('../refinery/blog/version', __FILE__)
    autoload :Tab, File.expand_path("../refinery/blog/tabs", __FILE__)

    class << self
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
          plugin.name = "refinerycms_blog"
          plugin.url = {:controller => '/admin/blog/posts', :action => 'index'}
          plugin.menu_match = /^\/?(admin|refinery)\/blog\/?(posts|comments|categories)?/
          plugin.activity = {
            :class => BlogPost
          }
        end

        # refinery 0.9.8 had a bug that we later found through using this engine.
        # the bug was that the plugin urls were not :controller => '/admin/whatever'
        if Refinery.version == '0.9.8'
          ::Refinery::Plugin.class_eval do
            alias_method :old_url, :url

            def url
              if (plugin_url = self.old_url).is_a?(Hash) and plugin_url[:controller] =~ %r{^admin}
                plugin_url[:controller] = "/#{plugin_url[:controller]}"
              end

              plugin_url
            end
          end
        end
      end
    end if defined?(Rails::Engine)
  end
end
