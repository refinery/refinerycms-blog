class BlogComment < ActiveRecord::Base

  filters_spam :author_field => :name,
               :email_field => :email,
               :message_field => :body

  belongs_to :post, :class_name => 'BlogPost'

  acts_as_indexed :fields => [:name, :email, :message]

  alias_attribute :message, :body

  validates_presence_of :name, :message
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  named_scope :unmoderated, :conditions => {:state => nil}
  named_scope :approved, :conditions => {:state => 'approved'}
  named_scope :rejected, :conditions => {:state => 'rejected'}

  before_create do |comment|
    unless BlogComment::Moderation.enabled?
      comment.state = comment.spam? ? 'rejected' : 'approved'
    end
  end

  module Moderation
    class << self
      def enabled?
        RefinerySetting.find_or_set(:comment_moderation, true, {
          :scoping => :blog
        })
      end

      def toggle
        RefinerySetting[:comment_moderation] = {
          :value => !self.enabled?,
          :scoping => :blog
        }
      end
    end
  end

  module Notification
    class << self
      def recipients
        RefinerySetting.find_or_set(
          :comment_notification_recipients,
          (Role[:refinery].users.first.email rescue ''),
          {:scoping => :blog}
        )
      end

      def recipients=(emails)
        RefinerySetting[:comment_notification_recipients] = {
          :value => emails,
          :scoping => :blog
        }
      end
    end
  end

end