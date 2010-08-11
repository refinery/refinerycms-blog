class BlogComment < ActiveRecord::Base

  belongs_to :post, :class_name => 'BlogPost'

  acts_as_indexed :fields => [:name, :email, :body]

  named_scope :unmoderated, :conditions => {:state => nil}
  named_scope :approved, :conditions => {:state => 'approved'}
  named_scope :rejected, :conditions => {:state => 'rejected'}

  module Moderation
    class << self
      def enabled?
        RefinerySetting.find_or_set(:comment_moderation, true, {:scoping => :blog})
      end

      def toggle
        RefinerySetting[:comment_moderation] = !self.enabled?
      end
    end
  end

  module Notification
    class << self
      def recipients
        RefinerySetting.find_or_set(
          :comment_notification_recipients, (Role[:refinery].users.first.email rescue ''), {:scoping => :blog}
        )
      end

      def recipients=(emails)
        RefinerySetting[:comment_notification_recipients] = emails
      end
    end
  end

end