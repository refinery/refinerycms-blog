class Admin::Blog::SettingsController < Admin::BaseController

  def update_notified

  end

  def moderation
    BlogComment::Moderation.toggle
    redirect_back_or_default(admin_blog_posts_path)
  end

end
