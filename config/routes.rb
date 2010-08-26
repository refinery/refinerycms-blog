ActionController::Routing::Routes.draw do |map|
  map.blog_post '/blog', :controller => :blog_posts, :action => :index
  map.blog_post '/blog/:id', :controller => :blog_posts, :action => :show
  map.blog_category '/blog/categories/:category_id', :controller => :blog_posts, :action => :index

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.namespace :blog do |blog|
      blog.resources :posts
      blog.resources :categories
      blog.resources :comments, :collection => {
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
