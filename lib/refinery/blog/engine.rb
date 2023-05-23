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
        tabs = [
          {title: 'Body',               partial: 'visual_editor_text',  fields: :body},
          {title: 'Teaser',             partial: 'teaser',              fields: :custom_teaser},
          {title: 'Tags & Categories',  partial: 'tags_and_categories', fields: [:tags, :categories]},
          {title: 'SEO',                partial: 'seo'},
          {title: 'Metadata',           partial: 'metadata',
           fields:[ :published_at, :custom_url, :source_url_title, :source_url, :author]}
        ]
        tabs.each do |t|
          Refinery::Blog::Tab.register do |tab|
            tab.name = t[:title]
            tab.partial = "/refinery/blog/admin/posts/tabs/#{t[:partial]}"
            tab.fields = t[:fields]
          end
        end
        Refinery.register_engine(Refinery::Blog)
      end

    end
  end
end
