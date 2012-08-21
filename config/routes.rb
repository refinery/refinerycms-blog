Refinery::Core::Engine.routes.draw do
  namespace :blog do
    root :to => "posts#index"
    resources :posts, :only => [:show]

    resources :blogs

    match 'feed.rss', :to => 'posts#index', :as => 'rss_feed', :defaults => {:format => "rss"}
    match 'categories/:id', :to => 'categories#show', :as => 'category'
    match ':id/comments', :to => 'posts#comment', :as => 'comments'
    get 'archive/:year(/:month)', :to => 'posts#archive', :as => 'archive_posts'
    get 'tagged/:tag_id(/:tag_name)' => 'posts#tagged', :as => 'tagged_posts'
  end

  namespace :blog, :path => '' do
    namespace :admin, :path => 'refinery' do

      resources :blogs do
        collection do
          post :update_positions
        end

        resources :posts do
          collection do
            get :uncategorized
            get :tags
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
