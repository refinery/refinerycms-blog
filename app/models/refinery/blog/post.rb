require 'acts-as-taggable-on'
require 'friendly_id'
require 'friendly_id/mobility'
require 'mobility'

module Refinery
  module Blog
    class Post < ActiveRecord::Base
      extend Mobility
      translates :title, :body, :custom_url, :custom_teaser, :slug, :browser_title, :meta_description

      after_save { translations.in_locale(Mobility.locale).seo_meta.save! }

      class Translation
        is_seo_meta
      end

      class FriendlyIdOptions
        def self.options
          # Docs for friendly_id https://github.com/norman/friendly_id
          friendly_id_options = {
            use: [:mobility, :reserved],
            reserved_words: Refinery::Pages.friendly_id_reserved_words
          }
          if ::Refinery::Blog.scope_slug_by_parent
            friendly_id_options[:use] << :scoped
            friendly_id_options.merge!(scope: :parent)
          end

          friendly_id_options
        end
      end
      extend FriendlyId
      friendly_id :friendly_id_source, use:  [:mobility, :slugged]

      acts_as_taggable

      belongs_to :author, proc { readonly(true) }, class_name: Refinery::Blog.user_class.to_s, foreign_key: :user_id, optional: true

      has_many :comments, :dependent => :destroy, :foreign_key => :blog_post_id
      has_many :categorizations, :dependent => :destroy, :foreign_key => :blog_post_id, inverse_of: :blog_post
      has_many :categories, :through => :categorizations, :source => :blog_category

      validates :title, :presence => true, :uniqueness => true
      validates :body, :presence => true
      validates :published_at, :presence => true
      validates :author, :presence => true, if: :author_required?
      validates :username, :presence => true, unless: :author_required?
      validates :source_url, url: {
        if: :validating_source_urls?,
        update: true,
        allow_nil: true,
        allow_blank: true,
        verify: [:resolve_redirects]
      }

      def validating_source_urls?
        Refinery::Blog.validate_source_url
      end

      # Override this to disable required authors
      def author_required?
        !Refinery::Blog.user_class.nil?
      end

      # If custom_url or title changes tell friendly_id to regenerate slug when
      # saving record
      def should_generate_new_friendly_id?
        saved_change_to_attribute?(:custom_url) || saved_change_to_attribute?(:title)
      end

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

      def author_username
        author.try(:username) || username
      end

      class << self

        # Wrap up the logic of finding the pages based on the translations table.
        def with_mobility(conditions = {})
          conditions = {:locale => ::Mobility.locale}.merge(conditions)
          mobilitized_conditions = {}
          conditions.keys.each do |key|
            if (translated_attribute_names.map(&:to_s) | %w(locale)).include?(key.to_s)
              mobilitized_conditions["#{Post::Translation.table_name}.#{key}"] = conditions.delete(key)
            end
          end
          # A join implies readonly which we don't really want.
          where(conditions).joins(:translations).where(mobilitized_conditions)
            .readonly(false)
        end

        def by_month(date)
          newest_first.where(:published_at => date.beginning_of_month..date.end_of_month)
        end

        def by_year(date)
          newest_first.where(:published_at => date.beginning_of_year..date.end_of_year).with_mobility
        end

        def by_title(title)
          joins(:translations).find_by(:title => title)
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
          order("access_count DESC").limit(count).with_mobility
        end

        def previous(item)
          newest_first.published_before(item.published_at).first
        end

        def uncategorized
          newest_first.live.includes(:categories).where(
            Refinery::Blog::Categorization.table_name => {:blog_category_id => nil}
          )
        end

        def next(current_record)
          where(arel_table[:published_at].gt(current_record.published_at))
            .where(:draft => false)
            .order('published_at ASC').with_mobility.first
        end

        def published_before(date=Time.now)
          where(arel_table[:published_at].lt(date))
            .where(:draft => false)
            .with_mobility
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
