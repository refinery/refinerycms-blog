Gem::Specification.new do |s|
  s.name              = %q{refinerycms-blog}
  s.version           = %q{1.7.0}
  s.description       = %q{A really straightforward open source Ruby on Rails blog engine designed for integration with RefineryCMS.}
  s.date              = %q{2011-12-05}
  s.summary           = %q{Ruby on Rails blogging engine for RefineryCMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com/blog}
  s.authors           = ['Resolve Digital', 'Neoteric Design']
  s.require_paths     = %w(lib)

  # Runtime dependencies
  s.add_dependency    'refinerycms-core',   '~> 1.0.3'
  s.add_dependency    'filters_spam',       '~> 0.2'
  s.add_dependency    'acts-as-taggable-on'
  s.add_dependency    'seo_meta',           '~> 1.1.0'

  # Development dependencies
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency "rake"

  s.files             = %w(
    app
    app/controllers
    app/controllers/admin
    app/controllers/admin/blog
    app/controllers/admin/blog/categories_controller.rb
    app/controllers/admin/blog/comments_controller.rb
    app/controllers/admin/blog/posts_controller.rb
    app/controllers/admin/blog/settings_controller.rb
    app/controllers/blog
    app/controllers/blog/categories_controller.rb
    app/controllers/blog/posts_controller.rb
    app/controllers/blog_controller.rb
    app/helpers
    app/helpers/blog_posts_helper.rb
    app/mailers
    app/mailers/blog
    app/mailers/blog/comment_mailer.rb
    app/models
    app/models/blog
    app/models/blog/comment_mailer.rb
    app/models/blog_category.rb
    app/models/blog_comment.rb
    app/models/blog_post.rb
    app/models/categorization.rb
    app/views
    app/views/admin
    app/views/admin/blog
    app/views/admin/blog/_submenu.html.erb
    app/views/admin/blog/categories
    app/views/admin/blog/categories/_category.html.erb
    app/views/admin/blog/categories/_form.html.erb
    app/views/admin/blog/categories/_sortable_list.html.erb
    app/views/admin/blog/categories/edit.html.erb
    app/views/admin/blog/categories/index.html.erb
    app/views/admin/blog/categories/new.html.erb
    app/views/admin/blog/comments
    app/views/admin/blog/comments/_comment.html.erb
    app/views/admin/blog/comments/_sortable_list.html.erb
    app/views/admin/blog/comments/index.html.erb
    app/views/admin/blog/comments/show.html.erb
    app/views/admin/blog/posts
    app/views/admin/blog/posts/_form.css.erb
    app/views/admin/blog/posts/_form.html.erb
    app/views/admin/blog/posts/_form.js.erb
    app/views/admin/blog/posts/_form_part.html.erb
    app/views/admin/blog/posts/_post.html.erb
    app/views/admin/blog/posts/_sortable_list.html.erb
    app/views/admin/blog/posts/_teaser_part.html.erb
    app/views/admin/blog/posts/edit.html.erb
    app/views/admin/blog/posts/index.html.erb
    app/views/admin/blog/posts/new.html.erb
    app/views/admin/blog/posts/uncategorized.html.erb
    app/views/admin/blog/settings
    app/views/admin/blog/settings/notification_recipients.html.erb
    app/views/blog
    app/views/blog/categories
    app/views/blog/categories/show.html.erb
    app/views/blog/comment_mailer
    app/views/blog/comment_mailer/notification.html.erb
    app/views/blog/posts
    app/views/blog/posts/_comment.html.erb
    app/views/blog/posts/_nav.html.erb
    app/views/blog/posts/_post.html.erb
    app/views/blog/posts/archive.html.erb
    app/views/blog/posts/index.html.erb
    app/views/blog/posts/index.rss.builder
    app/views/blog/posts/show.html.erb
    app/views/blog/posts/tagged.html.erb
    app/views/blog/shared
    app/views/blog/shared/_categories.html.erb
    app/views/blog/shared/_post.html.erb
    app/views/blog/shared/_posts.html.erb
    app/views/blog/shared/_rss_feed.html.erb
    app/views/blog/shared/_tags.html.erb
    app/views/shared
    app/views/shared/admin
    app/views/shared/admin/_autocomplete.html.erb
    changelog.md
    config
    config/locales
    config/locales/bg.yml
    config/locales/cs.yml
    config/locales/de.yml
    config/locales/en.yml
    config/locales/es.yml
    config/locales/fr.yml
    config/locales/it.yml
    config/locales/ja.yml
    config/locales/nb.yml
    config/locales/nl.yml
    config/locales/pl.yml
    config/locales/pt-BR.yml
    config/locales/ru.yml
    config/locales/sk.yml
    config/locales/zh-CN.yml
    config/routes.rb
    db
    db/migrate
    db/migrate/1_create_blog_structure.rb
    db/migrate/2_add_user_id_to_blog_posts.rb
    db/migrate/3_acts_as_taggable_on_migration.rb
    db/migrate/4_create_seo_meta_for_blog.rb
    db/migrate/5_add_cached_slugs.rb
    db/migrate/6_add_custom_url_field_to_blog_posts.rb
    db/migrate/7_add_custom_teaser_field_to_blog_posts.rb
    db/migrate/8_add_primary_key_to_categorizations.rb
    db/seeds
    db/seeds/refinerycms_blog.rb
    features
    features/authors.feature
    features/category.feature
    features/support
    features/support/factories
    features/support/factories/blog_categories.rb
    features/support/factories/blog_comments.rb
    features/support/factories/blog_posts.rb
    features/support/paths.rb
    features/support/step_definitions
    features/support/step_definitions/authors_steps.rb
    features/support/step_definitions/category_steps.rb
    features/support/step_definitions/tags_steps.rb
    features/tags.feature
    Gemfile
    Gemfile.lock
    lib
    lib/gemspec.rb
    lib/generators
    lib/generators/refinerycms_blog_generator.rb
    lib/refinery
    lib/refinery/blog
    lib/refinery/blog/tabs.rb
    lib/refinery/blog/version.rb
    lib/refinerycms-blog.rb
    public
    public/images
    public/images/refinerycms-blog
    public/images/refinerycms-blog/icons
    public/images/refinerycms-blog/icons/cog.png
    public/images/refinerycms-blog/icons/comment.png
    public/images/refinerycms-blog/icons/comment_cross.png
    public/images/refinerycms-blog/icons/comment_tick.png
    public/images/refinerycms-blog/icons/comments.png
    public/images/refinerycms-blog/icons/down.gif
    public/images/refinerycms-blog/icons/folder.png
    public/images/refinerycms-blog/icons/folder_add.png
    public/images/refinerycms-blog/icons/folder_edit.png
    public/images/refinerycms-blog/icons/page.png
    public/images/refinerycms-blog/icons/page_add.png
    public/images/refinerycms-blog/icons/page_copy.png
    public/images/refinerycms-blog/icons/up.gif
    public/images/refinerycms-blog/rss-feed.png
    public/javascripts
    public/javascripts/refinery
    public/javascripts/refinery/refinerycms-blog.js
    public/javascripts/refinerycms-blog.js
    public/stylesheets
    public/stylesheets/refinery
    public/stylesheets/refinery/refinerycms-blog.css
    public/stylesheets/refinerycms-blog.css
    public/stylesheets/ui-lightness
    public/stylesheets/ui-lightness/images
    public/stylesheets/ui-lightness/images/ui-bg_diagonals-thick_18_b81900_40x40.png
    public/stylesheets/ui-lightness/images/ui-bg_diagonals-thick_20_666666_40x40.png
    public/stylesheets/ui-lightness/images/ui-bg_flat_10_000000_40x100.png
    public/stylesheets/ui-lightness/images/ui-bg_glass_100_f6f6f6_1x400.png
    public/stylesheets/ui-lightness/images/ui-bg_glass_100_fdf5ce_1x400.png
    public/stylesheets/ui-lightness/images/ui-bg_glass_65_ffffff_1x400.png
    public/stylesheets/ui-lightness/images/ui-bg_gloss-wave_35_f6a828_500x100.png
    public/stylesheets/ui-lightness/images/ui-bg_highlight-soft_100_eeeeee_1x100.png
    public/stylesheets/ui-lightness/images/ui-bg_highlight-soft_75_ffe45c_1x100.png
    public/stylesheets/ui-lightness/images/ui-icons_222222_256x240.png
    public/stylesheets/ui-lightness/images/ui-icons_228ef1_256x240.png
    public/stylesheets/ui-lightness/images/ui-icons_ef8c08_256x240.png
    public/stylesheets/ui-lightness/images/ui-icons_ffd27a_256x240.png
    public/stylesheets/ui-lightness/images/ui-icons_ffffff_256x240.png
    public/stylesheets/ui-lightness/jquery-ui-1.8.13.custom.css
    readme.md
    refinerycms-blog.gemspec
    spec
    spec/models
    spec/models/blog_category_spec.rb
    spec/models/blog_comment_spec.rb
    spec/models/blog_post_spec.rb
    todo.md
  )
  
end
