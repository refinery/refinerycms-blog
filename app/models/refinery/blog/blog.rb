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

      class Translation
        attr_accessible :locale
      end      

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
