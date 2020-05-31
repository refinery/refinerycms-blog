module Refinery
  module Blog
    include ActiveSupport::Configurable

    config_accessor :validate_source_url, :comments_per_page, :posts_per_page,
      :post_teaser_length, :share_this_key, :page_url, :use_custom_slugs

    self.validate_source_url = false
    self.comments_per_page = 10
    self.posts_per_page = 10
    self.post_teaser_length = 250
    self.share_this_key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    self.page_url = "/blog"
    self.use_custom_slugs = false

    # Refinery::User isn't available when this line gets hit, so we use static methods instead
    @@user_class_name = nil
    class << self
      def user_class=(class_name)
        if class_name.is_a?(Class)
          raise TypeError, "You can't set user_class to be a class, e.g., User.  Instead, please use a string like 'User'"
        elsif class_name.is_a?(String)
          @@user_class_name = class_name
        else
          raise TypeError, "Invalid type for user_class.  Please use a string like 'User'"
        end
      end

      def user_class
        class_name = @@user_class_name
        begin
          Object.const_get(class_name) if class_name.present?
        rescue NameError
          class_name.constantize
        end
      end
    end
  end
end
