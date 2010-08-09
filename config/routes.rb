ActionController::Routing::Routes.draw do |map|
  map.resources :blog_posts, :as => :blog

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :blog_posts, :collection => {:update_positions => :post}
  end
end
