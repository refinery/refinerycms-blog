class BlogComment < ActiveRecord::Base

  attr_accessible :name, :email, :message

  filters_spam :author_field => :name,
               :email_field => :email,
               :message_field => :body

  belongs_to :post, :class_name => 'BlogPost', :foreign_key => 'blog_post_id'

  acts_as_indexed :fields => [:name, :email, :message]

  alias_attribute :message, :body

  validates :name, :message, :presence => true
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }                   

  scope :unmoderated, :conditions => {:state => nil}
  scope :approved, :conditions => {:state => 'approved'}
  scope :rejected, :conditions => {:state => 'rejected'}

  def approve!
    self.update_attribute(:state, 'approved')
  end

  def reject!
    self.update_attribute(:state, 'rejected')
  end

  def rejected?
    self.state == 'rejected'
  end

  def approved?
    self.state == 'approved'
  end

  def unmoderated?
    self.state.nil?
  end

  before_create do |comment|
    unless BlogComment::Moderation.enabled?
      comment.state = comment.ham? ? 'approved' : 'rejected'
    end
  end

  module Moderation
    class << self
      def enabled?
        RefinerySetting.find_or_set(:comment_moderation, true, {
          :scoping => 'blog',
          :restricted => false
        })
      end

      def toggle!
        new_value = {
          :value => !BlogComment::Moderation.enabled?,
          :scoping => 'blog',
          :restricted => false
        }
        if RefinerySetting.respond_to?(:set)
          RefinerySetting.set(:comment_moderation, new_value)
        else
          RefinerySetting[:comment_moderation] = new_value
        end
      end
    end
  end

  module Notification
    class << self
      def recipients
        RefinerySetting.find_or_set(:comment_notification_recipients, (Role[:refinery].users.first.email rescue ''),
        {
          :scoping => 'blog',
          :restricted => false
        })
      end

      def recipients=(emails)
        new_value = {
          :value => emails,
          :scoping => 'blog',
          :restricted => false
        }
        if RefinerySetting.respond_to?(:set)
          RefinerySetting.set(:comment_notification_recipients, new_value)
        else
          RefinerySetting[:comment_notification_recipients] = new_value
        end
      end

      def subject
        RefinerySetting.find_or_set(:comment_notification_subject, "New inquiry from your website", {
          :scoping => 'blog',
          :restricted => false
        })
      end

      def subject=(subject_line)
        new_value = {
          :value => subject_line,
          :scoping => 'blog',
          :restricted => false
        }
        if RefinerySetting.respond_to?(:set)
          RefinerySetting.set(:comment_notification_subject, new_value)
        else
          RefinerySetting[:comment_notification_subject] = new_value
        end
      end
    end
  end

end
