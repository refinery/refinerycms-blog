ActionController::Routing::Routes.draw do |map|
  map.resources :blog_posts, :as => :blog

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.namespace :blog do |blog|
      blog.resources :posts, :collection => {:update_positions => :post}
    end
  end
end
