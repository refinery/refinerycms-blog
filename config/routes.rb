Refinery::Core::Engine.routes.draw do
  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the
  # configuration option `mounted_path` to something different in config/initializers/refinery/core.rb
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  # mount Refinery::Core::Engine, at: Refinery::Core.mounted_path


  namespace :blog, :path => Refinery::Blog.page_url do
    root :to => "posts#index"
    resources :posts, :only => [:show]

    get 'feed.rss', :to => 'posts#index', :as => 'rss_feed', :defaults => {:format => "rss"}
    get 'categories/:id', :to => 'categories#show', :as => 'category'
    post ':id/comments', :to => 'posts#comment', :as => 'comments'
    get 'archive/:year(/:month)', :to => 'posts#archive', :as => 'archive_posts'
    get 'tagged/:tag_id(/:tag_name)' => 'posts#tagged', :as => 'tagged_posts'
  end

  namespace :blog, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      scope :path => Refinery::Blog.page_url do
        root :to => "posts#index"

        resources :posts do
          collection do
            get :uncategorized
            get :tags
          end
          member do
            post :delete_translation
          end
        end

        resources :categories

        resources :comments do
          collection do
            get :approved
            get :rejected
          end
          member do
            post :approve
            post :reject
          end
        end

        resources :settings do
          collection do
            get :notification_recipients
            post :notification_recipients

            get :moderation
            get :comments
            get :teasers
          end
        end
      end
    end
  end
end
