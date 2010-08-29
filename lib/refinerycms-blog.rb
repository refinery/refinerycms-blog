require 'filters_spam' if defined?(Bundler)

module Refinery
  module Blog

    class Engine < Rails::Engine
      initializer 'blog serves assets' do
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
      end
    end if defined?(Rails::Engine)

    class << self
      def version
        %q{0.9.8.0.rc2}
      end
    end
  end
end