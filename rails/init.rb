Refinery::Plugin.register do |plugin|
  plugin.name = "refinerycms_blog"
  plugin.url = {:controller => '/admin/blog_posts', :action => 'index'}
  plugin.menu_match = /^\/?(admin|refinery)\/blog_(posts|comments|categories)/
  plugin.activity = {
    :class => BlogPost
  }

  plugin.directory = directory # tell refinery where this plugin is located
end
