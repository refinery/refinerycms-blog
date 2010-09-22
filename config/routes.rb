if Rails.version < '3.0.0'
  ActionController::Routing::Routes.draw do |map|
    map.namespace(:blog) do |blog|
      blog.rss_feed 'feed.rss', :controller => 'posts', :action => 'index', :format => 'rss'
      blog.root :controller => "posts", :action => 'index'
      blog.post ':id', :controller => "posts", :action => 'show'
      blog.category 'categories/:id', :controller => "categories", :action => 'show'
      blog.post_blog_comments ':id/comments', :controller => 'posts', :action => 'comment'
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
else
  Refinery::Application.routes.draw do
    scope(:path => 'blog', :module => 'blog') do
      root :to => 'posts#index', :as => 'blog_root'
      match 'feed.rss', :to => 'posts#index.rss', :as => 'blog_rss_feed'
      match ':id', :to => 'posts#show', :as => 'blog_post'
      match 'categories/:id', :to => 'categories#show', :as => 'blog_category'
      match ':id/comments', :to => 'posts#comment', :as => 'blog_post_blog_comments'
    end

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