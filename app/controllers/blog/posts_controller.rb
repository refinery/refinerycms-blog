class Blog::PostsController < BlogController

  before_filter :find_all_blog_posts
  before_filter :find_blog_post, :only => [:show, :comment]

  def show
    @blog_comment = BlogComment.new

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @blogs in the line below:
    present(@page)
  end

  def comment
    if (@blog_comment = @blog_post.comments.create(params[:blog_comment])).valid?
      if BlogComment::Moderation.enabled?
        flash[:notice] = t('blog_posts.show.comments.thank_you_moderated')
        redirect_to blog_post_url(params[:id])
      else
        flash[:notice] = t('blog_posts.show.comments.thank_you')
        redirect_to blog_post_url(params[:id],
                                  :anchor => "comment-#{@blog_comment.to_param}")
      end
    else
      render :action => 'show'
    end
  end

protected

  def find_blog_post
    @blog_post = BlogPost.live.find(params[:id])
  end

  def find_all_blog_posts
    @blog_posts = BlogPost.live
  end

end
