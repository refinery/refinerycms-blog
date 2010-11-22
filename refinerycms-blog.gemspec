Gem::Specification.new do |s|
  s.name              = %q{refinerycms-blog}
  s.version           = %q{1.0.rc16}
  s.description       = %q{A really straightforward open source Ruby on Rails blog engine designed for integration with RefineryCMS.}
  s.date              = %q{2010-11-22}
  s.summary           = %q{Ruby on Rails blogging engine for RefineryCMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = %w(Resolve\ Digital Neoteric\ Design)
  s.require_paths     = %w(lib)
  s.add_dependency    'refinerycms',  '>= 0.9.7.13'
  s.add_dependency    'filters_spam', '~> 0.2'

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
    app/views/admin/blog/posts/_post.html.erb
    app/views/admin/blog/posts/_sortable_list.html.erb
    app/views/admin/blog/posts/edit.html.erb
    app/views/admin/blog/posts/index.html.erb
    app/views/admin/blog/posts/new.html.erb
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
    app/views/blog/shared
    app/views/blog/shared/_categories.html.erb
    app/views/blog/shared/_post.html.erb
    app/views/blog/shared/_posts.html.erb
    app/views/blog/shared/_rss_feed.html.erb
    config
    config/locales
    config/locales/en.yml
    config/locales/it.yml
    config/locales/nb.yml
    config/locales/nl.yml
    config/routes.rb
    Gemfile
    Gemfile.lock
    generators
    generators/refinerycms_blog
    generators/refinerycms_blog/refinerycms_blog_generator.rb
    generators/refinerycms_blog/templates
    generators/refinerycms_blog/templates/db
    generators/refinerycms_blog/templates/db/migrate
    generators/refinerycms_blog/templates/db/migrate/migration.rb
    generators/refinerycms_blog/templates/db/seeds
    generators/refinerycms_blog/templates/db/seeds/seed.rb
    lib
    lib/gemspec.rb
    lib/generators
    lib/generators/refinerycms_blog
    lib/generators/refinerycms_blog/templates
    lib/generators/refinerycms_blog/templates/db
    lib/generators/refinerycms_blog/templates/db/migrate
    lib/generators/refinerycms_blog/templates/db/migrate/migration_number_create_singular_name.rb
    lib/generators/refinerycms_blog/templates/db/seeds
    lib/generators/refinerycms_blog/templates/db/seeds/seed.rb
    lib/generators/refinerycms_blog_generator.rb
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
    rails
    rails/init.rb
    readme.md
    spec
    spec/models
    spec/models/blog_categories_spec.rb
    spec/models/blog_comments_spec.rb
    spec/models/blog_posts_spec.rb
  )
  
end
