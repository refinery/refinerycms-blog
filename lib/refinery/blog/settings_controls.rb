module Refinery
  module Blog
    module SettingsControls

      def settings_scope
        persisted? ? "blog-#{self.id}" : nil
      end

      def comments_allowed?
        Refinery::Setting.find_or_set(:comments_allowed, true, :scoping => settings_scope) if persisted?
      end

      def comments_allowed_toggle!
        if persisted?
          currently = Refinery::Setting.find_or_set(:comments_allowed, true, {:scoping => settings_scope})
          Refinery::Setting.set(:comments_allowed, {:value => !currently, :scoping => settings_scope})
        end
      end

      def teasers_enabled?
        Refinery::Setting.find_or_set(:teasers_enabled, true, :scoping => settings_scope) if persisted?
      end

      def teaser_enabled_toggle!
        if persisted?
          currently = Refinery::Setting.find_or_set(:teasers_enabled, true, :scoping => settings_scope)
          Refinery::Setting.set(:teasers_enabled, :value => !currently, :scoping => settings_scope)
        end
      end
      
      def comments_moderation_enabled?
        Refinery::Setting.find_or_set(:comment_moderation, true, {
                                        :scoping => settings_scope,
                                        :restricted => false
                                      })
      end
      def comments_moderation_toggle!
        new_value = {
          :value => !Blog::Comment::Moderation.enabled?,
          :scoping => settings_scope,
          :restricted => false
        }
        Refinery::Setting.set(:comment_moderation, new_value)
      end


      def comments_notiticacion_recipients
        Refinery::Setting.find_or_set(:comment_notification_recipients, (Refinery::Role[:refinery].users.first.email rescue ''),
                                      {
                                        :scoping => settings_scope,
                                        :restricted => false
                                      })
      end
      def comments_notifications_recipients=(emails)
        new_value = {
          :value => emails,
          :scoping => settings_scope,
          :restricted => false
        }
        Refinery::Setting.set(:comment_notification_recipients, new_value)
      end

      def comments_notifications_subject
        Refinery::Setting.find_or_set(:comment_notification_subject, "New inquiry from your website", {
                                        :scoping => settings_scope,
                                        :restricted => false
                                      })
      end
      def comments_notifications_subject=(subject_line)
        new_value = {
          :value => subject_line,
          :scoping => settings_scope,
          :restricted => false
        }
        Refinery::Setting.set(:comment_notification_subject, new_value)
      end

    end
  end
end
