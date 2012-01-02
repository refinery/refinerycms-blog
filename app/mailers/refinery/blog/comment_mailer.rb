module Refinery
  module Blog
    class CommentMailer < ActionMailer::Base

      def notification(comment, request)
        @blog_comment = comment
        mail :subject => Blog::Comment::Notification.subject,
             :recipients => Blog::Comment::Notification.recipients,
             :from => "\"#{Refinery::Core.config.site_name}\" <no-reply@#{request.domain}>"
      end

    end
  end
end
