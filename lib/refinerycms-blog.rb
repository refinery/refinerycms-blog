if defined?(Bundler) and !defined?(FiltersSpam)
  # this will tell the user what to do
  load(File.expand_path('../../Gemfile', __FILE__))
  require 'filters_spam'
end

module Refinery
  module Blog

    class Engine < Rails::Engine
      initializer 'blog serves assets' do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
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
          ::Refinery::Plugin.class_eval %{
            alias_method :old_url, :url

            def url
              if (plugin_url = self.old_url).is_a?(Hash) and plugin_url[:controller] =~ %r{^admin}
                plugin_url[:controller] = "/\#{plugin_url[:controller]}"
              end

              plugin_url
            end
          }
        end
      end
    end if defined?(Rails::Engine)

    class << self
      def version
        %q{1.0.rc13}
      end
    end
  end
end