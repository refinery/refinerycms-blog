require 'acts-as-taggable-on'
require 'seo_meta'

module Refinery
  module Blog
    class Post < ActiveRecord::Base
      extend FriendlyId
      friendly_id :friendly_id_source, :use => [:slugged]

      is_seo_meta if self.table_exists?

      default_scope :order => 'published_at DESC'

      belongs_to :author, :class_name => 'Refinery::User', :foreign_key => :user_id, :readonly => true

      has_many :comments, :dependent => :destroy, :foreign_key => :blog_post_id
      acts_as_taggable

      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_post_id
      has_many :categories, :through => :categorizations, :source => :blog_category

      acts_as_indexed :fields => [:title, :body]

      validates :title, :presence => true, :uniqueness => true
      validates :body,  :presence => true

      validates :source_url, :url => { :if => 'Refinery::Blog.validate_source_url',
                                      :update => true,
                                      :allow_nil => true,
                                      :allow_blank => true,
                                      :verify => [:resolve_redirects]}

      attr_accessible :title, :body, :custom_teaser, :tag_list, :draft, :published_at, :custom_url, :author
      attr_accessible :browser_title, :meta_keywords, :meta_description, :user_id, :category_ids
      attr_accessible :source_url, :source_url_title

      self.per_page = Refinery::Blog.posts_per_page

      def next
        self.class.next(self)
      end

      def prev
        self.class.previous(self)
      end

      def live?
        !draft and published_at <= Time.now
      end

      def friendly_id_source
        custom_url.present? ? custom_url : title
      end

      class << self
        def by_archive(date)
          where(:published_at => date.beginning_of_month..date.end_of_month)
        end

        def by_year(date)
          where(:published_at => date.beginning_of_year..date.end_of_year)
        end

        def published_dates_older_than(date)
          published_before(date).pluck(:published_at)
        end

        def recent(count)
          live.limit(count)
        end

        def popular(count)
          unscoped.order("access_count DESC").limit(count)
        end

        def previous(item)
          published_before(item.published_at).first
        end

        def uncategorized
          live.includes(:categories).where(:categories => { Refinery::Categorization.table_name => { :blog_category_id => nil } })
        end

        def next(current_record)
          where(["published_at > ? and draft = ?", current_record.published_at, false]).first
        end

        def published_before(date=Time.now)
          where("published_at < ? and draft = ?", date, false)
        end
        alias_method :live, :published_before

        def comments_allowed?
          Refinery::Setting.find_or_set(:comments_allowed, true, :scoping => 'blog')
        end

        def teasers_enabled?
          Refinery::Setting.find_or_set(:teasers_enabled, true, :scoping => 'blog')
        end

        def teaser_enabled_toggle!
          currently = Refinery::Setting.find_or_set(:teasers_enabled, true, :scoping => 'blog')
          Refinery::Setting.set(:teasers_enabled, :value => !currently, :scoping => 'blog')
        end
      end

      module ShareThis
        def self.enabled?
          Refinery::Blog.share_this_key != "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        end
      end

    end
  end
end
