module Refinery
  module Blog
    class Blog < Refinery::Core::BaseModel

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
    end
  end
end
