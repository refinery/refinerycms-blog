module Refinery
  module Blog
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery::Blog
      engine_name :refinery_blog

      initializer "register refinerycms_blog plugin", :after => :set_routes_reloader do |app|
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_blog"
          plugin.url = app.routes.url_helpers.refinery_blog_admin_posts_path
          plugin.menu_match = /refinery\/blog\/?(posts|comments|categories)?/
          plugin.activity = {
            :class_name => :'refinery/blog/post'
          }
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Blog)
      end
    end
  end
end
