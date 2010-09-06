if Rails.version < '3.0.0'
  ActionController::Routing::Routes.draw do |map|
    map.namespace(:blog) do |blog|
      blog.root :controller => "posts", :action => 'index'
      blog.post '/blog/:id', :controller => "posts", :action => 'show'
      blog.category '/blog/categories/:id', :controller => "categories", :action => 'show'
      blog.post_blog_comments '/blog/:id/comments', :controller => 'posts', :action => 'comment'
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
    scope(:path => 'blog') do
      root :to => 'posts#index'
      match ':id', :to => 'posts#show', :as => 'post'
      match 'categories/:id', :to => 'categories#show', :as => 'category'
      match ':id/comments', :to => 'posts#comment', :as => 'post_blog_comments'
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