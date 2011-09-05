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
        # TODO: Convert these to url helpers
        expire_page '/blog'
        expire_page '/blog/feed.rss'
      end
      
  end
end
