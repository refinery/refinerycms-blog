module Refinery
  module Blog
    class Comment < ActiveRecord::Base

      attr_accessible :name, :email, :message

      filters_spam :author_field => :name,
      :email_field => :email,
      :message_field => :body

      belongs_to :post, :foreign_key => 'blog_post_id'
      has_one :blog, :through => :post

      acts_as_indexed :fields => [:name, :email, :message]

      alias_attribute :message, :body

      validates :name, :message, :presence => true
      validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

      class << self
        def unmoderated
          where(:state => nil)
        end

        def approved
          where(:state => 'approved')
        end

        def rejected
          where(:state => 'rejected')
        end

        def for_blog(blog)
          joins(:post).where('refinery_blog_posts.blog_id' => blog.id)
        end
      end

      self.per_page = Refinery::Blog.comments_per_page

      def approve!
        self.update_column(:state, 'approved')
      end

      def reject!
        self.update_column(:state, 'rejected')
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
        unless comment.blog.comments_moderation_enabled?
          comment.state = comment.ham? ? 'approved' : 'rejected'
        end
      end

    end
  end
end
