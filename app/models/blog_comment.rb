class BlogComment < ActiveRecord::Base

  filters_spam :author_field => :name,
               :email_field => :email,
               :message_field => :body

  belongs_to :post, :class_name => 'BlogPost', :foreign_key => 'blog_post_id'

  acts_as_indexed :fields => [:name, :email, :message]

  alias_attribute :message, :body

  validates_presence_of :name, :message
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  if Rails.version < '3.0.0'
    named_scope :unmoderated, :conditions => {:state => nil}
    named_scope :approved, :conditions => {:state => 'approved'}
    named_scope :rejected, :conditions => {:state => 'rejected'}
  else
    scope :unmoderated, :conditions => {:state => nil}
    scope :approved, :conditions => {:state => 'approved'}
    scope :rejected, :conditions => {:state => 'rejected'}
  end

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
      comment.state = comment.spam? ? 'rejected' : 'approved'
    end
  end

  module Moderation
    class << self
      def enabled?
        RefinerySetting.find_or_set(:comment_moderation, true, {
          :scoping => :blog,
          :restricted => false,
          :callback_proc_as_string => nil
        })
      end

      def toggle!
        RefinerySetting[:comment_moderation] = {
          :value => !self.enabled?,
          :scoping => :blog,
          :restricted => false,
          :callback_proc_as_string => nil
        }
      end
    end
  end

  module Notification
    class << self
      def recipients
        RefinerySetting.find_or_set(:comment_notification_recipients,
                                    (Role[:refinery].users.first.email rescue ''),
                                    {
                                      :scoping => :blog,
                                      :restricted => false,
                                      :callback_proc_as_string => nil
                                    })
      end

      def recipients=(emails)
        RefinerySetting[:comment_notification_recipients] = {
          :value => emails,
          :scoping => :blog,
          :restricted => false,
          :callback_proc_as_string => nil
        }
      end
    end
  end

end