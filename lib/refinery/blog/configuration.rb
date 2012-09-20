module Refinery
  module Blog
    include ActiveSupport::Configurable

    config_accessor :validate_source_url, :comments_per_page, :posts_per_page,
      :post_teaser_length, :share_this_key, :page_url


    self.validate_source_url = false
    self.comments_per_page = 10
    self.posts_per_page = 10
    self.post_teaser_length = 250
    self.share_this_key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    self.page_url = "/blog"
    
    # Refinery::User isn't available when this line gets hit, so we use static methods instead
    @@user_class_name = nil
    def self.user_class= (class_name)
      if class_name.class == Class
        @@user_class_name = class_name
      else 
        raise TypeError, "Expecting configuration input of type Class."
      end
    end
    
    def self.user_class
      @@user_class_name || Refinery::User
    end
  end
end
