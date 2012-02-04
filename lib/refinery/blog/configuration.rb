module Refinery
  module Blog
    include ActiveSupport::Configurable

    config_accessor :validate_source_url, :comments_per_page, :posts_per_page,
      :post_teaser_length, :approximate_ascii, :strip_non_ascii, :share_this_key

    self.validate_source_url = false
    self.comments_per_page = 10
    self.posts_per_page = 10
    self.post_teaser_length = 250
    self.approximate_ascii = false
    self.strip_non_ascii = false
    self.share_this_key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  end
end
