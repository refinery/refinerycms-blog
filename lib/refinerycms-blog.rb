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
      end
    end if defined?(Rails::Engine)

    class << self
      def version
        %q{1.0.rc3}
      end
    end
  end
end