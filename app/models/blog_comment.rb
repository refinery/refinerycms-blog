class BlogComment < ActiveRecord::Base

  belongs_to :post, :class_name => 'BlogPost'

  acts_as_indexed :fields => [:name, :email, :body]

  named_scope :approved, :conditions => {:approved => true}
  named_scope :rejected, :conditions => {:approved => false}

  module Moderation
    class << self
      def enabled?
        RefinerySetting.find_or_set(:comment_moderation, {
          :value => true,
          :scoping => :blog
        })
      end

      def toggle
        currently = self.enabled?
        RefinerySetting[:comment_moderation] = !currently
      end
    end
  end

end
