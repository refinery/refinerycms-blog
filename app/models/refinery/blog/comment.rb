module Refinery
  module Blog
    class Comment < ActiveRecord::Base

      filters_spam author_field: :name, email_field: :email, message_field: :body

      belongs_to :post, foreign_key: 'blog_post_id'

      alias_attribute :message, :body

      validates :name, :message, presence: true
      validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

      class << self
        def unmoderated
          where(state: nil)
        end

        def approved
          where(state: 'approved')
        end

        def rejected
          where(state: 'rejected')
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

      def self.toggle!
        currently = Refinery::Setting.find_or_set(:comments_allowed, true, {
          :scoping => 'blog'
        })
        Refinery::Setting.set(:comments_allowed, {value: !currently, scoping: 'blog'})
      end

      before_create do |comment|
        unless Moderation.enabled?
          comment.state = comment.ham? ? 'approved' : 'rejected'
        end
      end

      module Moderation
        class << self
          def enabled?
            Refinery::Setting.find_or_set(:comment_moderation, true, {
              scoping: 'blog',
              restricted: false
            })
          end

          def toggle!
            new_value = {
              value: !Blog::Comment::Moderation.enabled?,
              scoping: 'blog',
              restricted: false
            }
            Refinery::Setting.set(:comment_moderation, new_value)
          end
        end
      end

      module Notification
        class << self
          def recipients
            Refinery::Setting.find_or_set(:comment_notification_recipients, (Refinery::Role[:refinery].users.first.email rescue ''),
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
            Refinery::Setting.set(:comment_notification_recipients, new_value)
          end

          def subject
            Refinery::Setting.find_or_set(:comment_notification_subject, "New inquiry from your website", {
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
            Refinery::Setting.set(:comment_notification_subject, new_value)
          end
        end
      end

    end
  end
end
