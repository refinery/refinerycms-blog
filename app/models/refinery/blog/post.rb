require 'acts-as-taggable-on'
require 'seo_meta'

module Refinery
  module Blog
    class Post < ActiveRecord::Base
      extend FriendlyId

      translates :title, :body, :custom_url, :custom_teaser, :slug, :include => :seo_meta

      friendly_id :friendly_id_source, :use => [:slugged, :globalize]

      is_seo_meta

      acts_as_taggable

      belongs_to :author, proc { readonly(true) }, :class_name => Refinery::Blog.user_class.to_s, :foreign_key => :user_id
      has_many :comments, :dependent => :destroy, :foreign_key => :blog_post_id
      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_post_id
      has_many :categories, :through => :categorizations, :source => :blog_category

      validates :title, :presence => true, :uniqueness => true
      validates :body,  :presence => true
      validates :published_at, :author, :presence => true
      validates :source_url, :url => { :if => 'Refinery::Blog.validate_source_url',
                                      :update => true,
                                      :allow_nil => true,
                                      :allow_blank => true,
                                      :verify => [:resolve_redirects]}

      class Translation
        is_seo_meta
      end

      # If custom_url or title changes tell friendly_id to regenerate slug when
      # saving record
      def should_generate_new_friendly_id?
        custom_url_changed? || title_changed?
      end

      # Delegate SEO Attributes to globalize translation
      seo_fields = ::SeoMeta.attributes.keys.map{|a| [a, :"#{a}="]}.flatten
      delegate(*(seo_fields << {:to => :translation}))

      self.per_page = Refinery::Blog.posts_per_page

      def next
        self.class.next(self)
      end

      def prev
        self.class.previous(self)
      end

      def live?
        !draft && published_at <= Time.now
      end

      def friendly_id_source
        custom_url.presence || title
      end

      class << self

        # Wrap up the logic of finding the pages based on the translations table.
        def with_globalize(conditions = {})
          conditions = {:locale => ::Globalize.locale}.merge(conditions)
          globalized_conditions = {}
          conditions.keys.each do |key|
            if (translated_attribute_names.map(&:to_s) | %w(locale)).include?(key.to_s)
              globalized_conditions["#{self.translation_class.table_name}.#{key}"] = conditions.delete(key)
            end
          end
          # A join implies readonly which we don't really want.
          where(conditions).joins(:translations).where(globalized_conditions)
                           .readonly(false)
        end

        def find_by_slug_or_id(slug_or_id)
          if slug_or_id.friendly_id?
            find_by_slug(slug_or_id)
          else
            find(slug_or_id)
          end
        end

        def by_month(date)
          newest_first.where(:published_at => date.beginning_of_month..date.end_of_month)
        end

        def by_year(date)
          newest_first.where(:published_at => date.beginning_of_year..date.end_of_year).with_globalize
        end

        def newest_first
          order("published_at DESC")
        end

        def published_dates_older_than(date)
          newest_first.published_before(date).select(:published_at).map(&:published_at)
        end

        def recent(count)
          newest_first.live.limit(count)
        end

        def popular(count)
          order("access_count DESC").limit(count).with_globalize
        end

        def previous(item)
          newest_first.published_before(item.published_at).first
        end

        def uncategorized
          newest_first.live.includes(:categories).where(
            Refinery::Blog::Categorization.table_name => { :blog_category_id => nil }
          )
        end

        def next(current_record)
          where(arel_table[:published_at].gt(current_record.published_at))
            .where(:draft => false)
            .order('published_at ASC').with_globalize.first
        end

        def published_before(date=Time.now)
          where(arel_table[:published_at].lt(date))
            .where(:draft => false)
            .with_globalize
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
