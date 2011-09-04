module Refinery
  class BlogSweeper < ActionController::Caching::Sweeper
    observe BlogPost, BlogComment
    
    def after_create(record)
      expire_cache_for(record)
    end
    
    def after_update(record)
      expire_cache_for(record)
    end
    
    def after_destroy(record)
      expire_cache_for(record)
    end
    
    private
    
      def expire_cache_for(record)
        expire_page main_app.blog_root_path
        expire_page main_app.blog_rss_feed_path
      end
      
  end
end
