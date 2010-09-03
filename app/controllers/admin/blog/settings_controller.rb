class Admin::Blog::SettingsController < Admin::BaseController

  def notification_recipients
    @recipients = BlogComment::Notification.recipients

    if request.post?
      BlogComment::Notification.recipients = params[:recipients]
      flash[:notice] = t('admin.blog.settings.notification_recipients.updated',
                         :recipients => BlogComment::Notification.recipients)
      unless request.xhr? or from_dialog?
        redirect_back_or_default(admin_blog_posts_path)
      else
        render :text => "<script type='text/javascript'>parent.window.location = '#{admin_blog_posts_path}';</script>"
      end
    end
  end

  def moderation
    enabled = BlogComment::Moderation.toggle!
    unless request.xhr?
      redirect_back_or_default(admin_blog_posts_path)
    else
      render :json => {:enabled => enabled}
    end
  end

end
