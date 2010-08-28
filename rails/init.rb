require File.expand_path('../../lib/refinerycms-blog', __FILE__)

Refinery::Plugin.register do |plugin|
  plugin.name = "refinerycms_blog"
  plugin.url = {:controller => '/admin/blog/posts', :action => 'index'}
  plugin.menu_match = /^\/?(admin|refinery)\/blog\/?(posts|comments|categories)?/
  plugin.activity = {
    :class => BlogPost
  }
end
