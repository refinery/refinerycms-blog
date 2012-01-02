module Refinery
  module Blog
    class CommentMailer < ActionMailer::Base

      def notification(comment, request)
        @blog_comment = comment
        mail :subject => Blog::Comment::Notification.subject,
             :recipients => Blog::Comment::Notification.recipients,
             :from => "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
      end

    end
  end
end
