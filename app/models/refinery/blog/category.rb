module Refinery
  module Blog
    class Category < ActiveRecord::Base

      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_category_id
      has_many :posts, :through => :categorizations, :source => :blog_post

      acts_as_indexed :fields => [:title]

      validates :title, :presence => true, :uniqueness => true

      has_friendly_id :title, :use_slug => true,
                      :default_locale => (Refinery::I18n.default_frontend_locale rescue :en),
                      :approximate_ascii => Refinery::Blog.approximate_ascii,
                      :strip_non_ascii => Refinery::Blog.strip_non_ascii

      def post_count
        posts.select(&:live?).count
      end

      # how many items to show per page
      self.per_page = Refinery::Blog.posts_per_page

    end
  end
end