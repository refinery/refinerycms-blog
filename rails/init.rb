Refinery::Plugin.register do |plugin|
  plugin.name = "refinerycms_blog"
  plugin.url = {:controller => '/admin/blog/posts', :action => 'index'}
  plugin.menu_match = /^\/?(admin|refinery)\/blog\/?(posts|comments|categories)?/
  plugin.activity = {
    :class => BlogPost
  }

  plugin.directory = directory # tell refinery where this plugin is located
end
