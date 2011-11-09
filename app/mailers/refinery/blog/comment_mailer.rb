module Refinery
  module Blog
    class CommentMailer < ActionMailer::Base

      def notification(comment, request)
        subject     Blog::Comment::Notification.subject
        recipients  Blog::Comment::Notification.recipients
        from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
        sent_on     Time.now
        @blog_comment =  comment
      end

    end
  end
end
