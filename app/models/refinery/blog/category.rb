module Refinery
  module Blog
    class Category < ActiveRecord::Base
      extend Mobility
      extend FriendlyId

      translates :title, :slug

      attribute :title
      attribute :slug
      after_save {translations.collect(&:save)}

      friendly_id :title, use: [:slugged, :mobility]

      has_many :categorizations, dependent: :destroy, foreign_key: :blog_category_id
      has_many :posts, through: :categorizations, source: :blog_post

      validates :title, presence: true, uniqueness: true

      def self.by_title(title)
        joins(:translations).find_by(title: title)
      end

      def self.translated
        translations.in_locale(Mobility.locale)
      end

      def post_count
        posts.live.with_mobility.count
      end

      # how many items to show per page
      self.per_page = Refinery::Blog.posts_per_page

      def translated_attributes
        Blog::Category.translated_attribute_names.map(&:to_s) | %w(locale)
      end

      def with_mobility(conditions = {})

        conditions = {:locale => ::Mobility.locale.to_s}.merge(conditions)
        mobility_conditions = {}
        conditions.keys.each do |key|
          if translated_attributes.include? key.to_s
            mobility_conditions["#{Blog::Category::Translation.table_name}.#{key}"] = conditions.delete(key)
          end
        end
        # A join implies readonly which we don't really want.
        where(conditions).
          joins(:translations).
          where(mobility_conditions).
          readonly(false)
      end

    end
  end
end
