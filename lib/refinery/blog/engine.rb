module Refinery
  module Blog
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery::Blog

      before_inclusion do
        Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = "refinerycms_blog"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.blog_admin_posts_path }
          plugin.menu_match = %r{refinery/blog/?(posts|comments|categories)?}
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Blog)
      end
    end
  end
end
