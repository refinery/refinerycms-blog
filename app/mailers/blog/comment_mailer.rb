class Blog::CommentMailer < ActionMailer::Base

  def notification(comment, request)
    subject     BlogComment::Notification.subject
    recipients  BlogComment::Notification.recipients
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on     Time.now
    @comment =  comment
  end

end
