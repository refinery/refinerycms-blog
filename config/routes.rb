ActionController::Routing::Routes.draw do |map|
  map.resources :blog_posts, :as => :blog

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
