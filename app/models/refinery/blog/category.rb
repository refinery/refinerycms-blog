module Refinery
  module Blog
    class Category < ActiveRecord::Base

      translates :title, :slug

      extend FriendlyId
      friendly_id :title, :use => [:slugged, :globalize]

      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_category_id
      has_many :posts, :through => :categorizations, :source => :blog_post

      acts_as_indexed :fields => [:title]

      validates :title, :presence => true, :uniqueness => true

      attr_accessible :title
      attr_accessor :locale

      class Translation
        attr_accessible :locale
      end

      def self.translated
        with_translations(::Globalize.locale)
      end

      def post_count
        posts.live.with_globalize.count
      end

      # how many items to show per page
      self.per_page = Refinery::Blog.posts_per_page

    end
  end
end
