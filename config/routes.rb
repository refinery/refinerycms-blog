ActionController::Routing::Routes.draw do |map|
  map.namespace(:blog) do |blog|
    blog.rss_feed 'feed.rss', :controller => 'posts', :action => 'index', :format => 'rss'
    blog.root :controller => "posts", :action => 'index'
    blog.post ':id', :controller => "posts", :action => 'show'
    blog.category 'categories/:id', :controller => "categories", :action => 'show'
    blog.post_blog_comments ':id/comments', :controller => 'posts', :action => 'comment'

    ## TODO: what is the rails2 syntax for this? sorry ;__;
    # get 'archive/:year/:month', :to => 'posts#archive', :as => 'archive_blog_posts'
  end

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.namespace :blog do |blog|
      blog.resources :posts

      blog.resources :categories

      blog.resources :comments, :collection => {
        :approved => :get,
        :rejected => :get
      }, :member => {
        :approved => :get,
        :rejected => :get
      }

      blog.resources :settings, :collection => {
        :notification_recipients => [:get, :post],
        :moderation => :get
      }
    end
  end
end
