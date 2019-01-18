module Refinery
  module Blog
    class Category < ActiveRecord::Base
      extend Mobility
      translates :title, :slug

      extend FriendlyId
      friendly_id :title, :use => [:mobility, :slugged]

      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_category_id
      has_many :posts, :through => :categorizations, :source => :blog_post

      validates :title, :presence => true, :uniqueness => true

      def self.by_title(title)
        joins(:translations).find_by(title: title)
      end

      def post_count
        posts.live.with_mobility.count
      end

      # how many items to show per page
      self.per_page = Refinery::Blog.posts_per_page

    end
  end
end
