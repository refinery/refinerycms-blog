require 'acts-as-taggable-on'
require 'seo_meta'

module Refinery
  module Blog
    class Post < ActiveRecord::Base

      is_seo_meta if self.table_exists?

      default_scope :order => 'published_at DESC'
      #.first & .last will be reversed -- consider a with_exclusive_scope on these?

      belongs_to :author, :class_name => 'Refinery::User', :foreign_key => :user_id, :readonly => true

      has_many :comments, :class_name => 'Refinery::Blog::Comment', :dependent => :destroy, :foreign_key => :blog_post_id
      acts_as_taggable

      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_post_id
      has_many :categories, :through => :categorizations, :source => :blog_category

      acts_as_indexed :fields => [:title, :body]

      validates :title, :presence => true, :uniqueness => true
      validates :body,  :presence => true

      validates :source_url, :url => { :if => 'Refinery::Blog.config.validate_source_url',
                                      :update => true,
                                      :allow_nil => true,
                                      :allow_blank => true,
                                      :verify => [:resolve_redirects]}

      has_friendly_id :friendly_id_source, :use_slug => true,
                      :default_locale => (::Refinery::I18n.default_frontend_locale rescue :en),
                      :approximate_ascii => Refinery::Setting.find_or_set(:approximate_ascii, false, :scoping => 'blog'),
                      :strip_non_ascii => Refinery::Setting.find_or_set(:strip_non_ascii, false, :scoping => 'blog')

      attr_accessible :title, :body, :custom_teaser, :tag_list, :draft, :published_at, :custom_url, :author
      attr_accessible :browser_title, :meta_keywords, :meta_description, :user_id, :category_ids
      attr_accessible :source_url, :source_url_title

      self.per_page = Refinery::Setting.find_or_set(:blog_posts_per_page, 10)

      def next
        self.class.next(self).first
      end

      def prev
        self.class.previous(self).first
      end

      def live?
        !draft and published_at <= Time.now
      end

      def category_ids=(ids)
        self.categories = ids.reject{|id| id.blank?}.collect {|c_id|
          Refinery::Blog::Category.find(c_id.to_i) rescue nil
        }.compact
      end

      def friendly_id_source
        custom_url.present? ? custom_url : title
      end

      class << self
        def by_archive(archive_date)
          where(['published_at between ? and ?', archive_date.beginning_of_month, archive_date.end_of_month])
        end

        def by_year(archive_year)
          where(['published_at between ? and ?', archive_year.beginning_of_year, archive_year.end_of_year])
        end

        def all_previous
          where(['published_at <= ?', Time.now.beginning_of_month])
        end

        def live
          where( "published_at <= ? and draft = ?", Time.now, false)
        end

        def previous(item)
          where(["published_at < ? and draft = ?", item.published_at, false]).limit(1)
        end

        def uncategorized
          live.includes(:categories).where(:categories => { Refinery::Categorization.table_name => { :blog_category_id => nil } })
        end

        def next(current_record)
          self.send(:with_exclusive_scope) do
            where(["published_at > ? and draft = ?", current_record.published_at, false]).order("published_at ASC")
          end
        end

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
        DEFAULT_KEY = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

        class << self
          def key
            Refinery::Setting.find_or_set(:share_this_key, Blog::Post::ShareThis::DEFAULT_KEY, :scoping => 'blog')
          end

          def enabled?
            key = Blog::Post::ShareThis.key
            key.present? and key != Blog::Post::ShareThis::DEFAULT_KEY
          end
        end
      end

    end
  end
end
