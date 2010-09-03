if Rails.version < '3.0.0'
  ActionController::Routing::Routes.draw do |map|
    map.blog_post '/blog', :controller => :blog_posts, :action => :index
    map.blog_post '/blog/:id', :controller => :blog_posts, :action => :show
    map.blog_category '/blog/categories/:category_id', :controller => :blog_posts, :action => :index
    map.blog_post_blog_comments '/blog/:id/comments', :controller => :blog_posts, :action => :comment

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
else
  Refinery::Application.routes.draw do
    match '/blog',      :to => 'blog_posts#index',    :as => 'blog_post'
    match '/blog/:id',  :to => 'blog_posts#show',     :as => 'blog_post'

    match '/blog/categories/:category_id', :to => 'blog_posts#index',   :as => 'blog_category'
    match '/blog/:id/comments',            :to => 'blog_posts#comment', :as => 'blog_post_blog_comments'

    scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
      scope(:path => 'blog', :name_prefix => 'admin', :as => 'blog', :module => 'blog') do
        root :to => 'posts#index'
        resources :posts

        resources :categories

        resources :comments do
          collection do
            get :approved
            get :rejected
          end
          member do
            get :approved
            get :rejected
          end
        end

        resources :settings do
          collection do
            get :notification_recipients
            post :notification_recipients

            get :moderation
          end
        end
      end
    end
  end
end