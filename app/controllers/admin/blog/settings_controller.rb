class Admin::Blog::SettingsController < Admin::BaseController

  def notification_recipients
    @recipients = BlogComment::Notification.recipients['value']

    if request.post?
      BlogComment::Notification.recipients == params[:recipients]
    end
  end

  def moderation
    enabled = BlogComment::Moderation.toggle
    unless request.xhr?
      redirect_back_or_default(admin_blog_posts_path)
    else
      render :json => {:enabled => enabled}
    end
  end

end
