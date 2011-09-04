module Refinery
  module Blog
    class Engine < Rails::Engine
      require 'rails_autolink'
      
      config.to_prepare do
        require 'refinery/blog/tabs'
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
    end
  end
end
