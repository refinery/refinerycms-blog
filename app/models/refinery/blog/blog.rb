require 'refinery/blog/settings_controls'

module Refinery
  module Blog
    class Blog < Refinery::Core::BaseModel

      include ::Refinery::Blog::SettingsControls

      translates :name, :slug

      extend FriendlyId
      friendly_id :name, :use => [:slugged, :globalize]

      has_many :posts, :dependent => :destroy
      has_many :categories, :dependent => :destroy

      attr_accessible :name, :position

      acts_as_indexed :fields => [:name]

      validates :name, :presence => true, :uniqueness => true

      after_create :create_page
      after_update :update_page
      after_destroy :destroy_page

      class Translation
        attr_accessible :locale
      end

      def create_page
        page_attrs = {
          :title => self.name,
          :link_url => "/blogs/#{self.slug}",
          :deletable => false,
          :menu_match => "^/blogs/#{self.slug}$"
        }
        if parent = Refinery::Page.find_by_link_url('/blogs')
          page_attrs[:parent_id] = parent.id
        end
        Refinery::Page.create(page_attrs)
      end

      def update_page
        if page = Refinery::Page.find_by_link_url("/blogs/#{self.slug_was}")
          page.update_attributes(
                                 :title => self.name,
                                 :link_url => "/blogs/#{self.slug}",
                                 :menu_match => "^/blogs/#{self.slug}$"
                                 )
        end
      end

      def destroy_page
        if page = Refinery::Page.find_by_link_url("/blogs/#{self.slug}")
          page.destroy!
        end
      end

      private :create_page, :update_page, :destroy_page

      class << self

        def find_by_slug_or_id(slug_or_id)
          if slug_or_id.friendly_id?
            find_by_slug(slug_or_id)
          else
            find(slug_or_id)
          end
        end

      end

    end
  end
end
