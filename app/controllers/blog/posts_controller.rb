class Blog::PostsController < BlogController

  before_filter :find_all_blog_posts, :except => [:archive]
  before_filter :find_blog_post, :only => [:show, :comment, :update_nav]

  def index
    # TODO: respond_to block
  end

  def show
    @blog_comment = BlogComment.new

    # TODO: respond_to block
  end

  def comment
    if (@blog_comment = @blog_post.comments.create(params[:blog_comment])).valid?
      if BlogComment::Moderation.enabled? or @blog_comment.ham?
        begin
          Blog::CommentMailer.deliver_notification(@blog_comment, request)
        rescue
          logger.warn "There was an error delivering a blog comment notification.\n#{$!}\n"
        end
      end

      if BlogComment::Moderation.enabled?
        flash[:notice] = t('blog.posts.comments.thank_you_moderated')
        redirect_to blog_post_url(params[:id])
      else
        flash[:notice] = t('blog.posts.comments.thank_you')
        redirect_to blog_post_url(params[:id],
                                  :anchor => "comment-#{@blog_comment.to_param}")
      end
    else
      render :action => 'show'
    end
  end

  def archive
    date = "#{params[:month]}/#{params[:year]}"
    @archive_date = Time.parse(date)
    @blog_posts = BlogPost.live.by_archive(@archive_date).paginate({
      :page => params[:page],
      :per_page => RefinerySetting.find_or_set(:blog_posts_per_page, 10)
    })
    # TODO: respond_to block
  end

protected

  def find_blog_post
    unless (@blog_post = BlogPost.find(params[:id])).try(:live?)
      if refinery_user? and current_user.authorized_plugins.include?("refinerycms_blog")
        @blog_post = BlogPost.find(params[:id])
      else
        error_404
      end
    end
  end

  def find_all_blog_posts
    @blog_posts = BlogPost.live.paginate({
      :page => params[:page],
      :per_page => RefinerySetting.find_or_set(:blog_posts_per_page, 10)
    })
  end

end
