class BlogPostsController < ApplicationController

  before_filter :find_all_blog_posts, :find_all_blog_categories
  before_filter :find_page
  before_filter :find_blog_post, :only => [:show, :comment]

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @blogs in the line below:
    present(@page)
  end

  def show
    @blog_comment = BlogComment.new

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @blogs in the line below:
    present(@page)
  end

  def comment
    if (@blog_comment = BlogComment.create(params[:blog_comment])).valid?
      if BlogComment::Moderation.enabled?
        flash[:notice] = t('.thank_you_moderated')
        redirect_back_or_default blog_post_url(params[:id])
      else
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
    unless params[:category_id].present?
      @blog_posts = BlogPost.live
    else
      if (category = BlogCategory.find(params[:category_id])).present?
        @blog_posts = category.posts
      else
        error_404
      end
    end
  end

  def find_all_blog_categories
    @blog_categories = BlogCategory.all
  end

  def find_page
    @page = Page.find_by_link_url("/blog")
  end

end
