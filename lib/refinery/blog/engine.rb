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

        Rails.application.config.assets.precompile += %w(
          refinery/blog/backend.js
          refinery/blog/backend.css
          refinery/blog/frontend.css
          refinery/blog/ui-lightness/jquery-ui-1.8.13.custom.css
        )
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Blog)
      end
    end
  end
end
