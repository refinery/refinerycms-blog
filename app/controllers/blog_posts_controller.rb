class BlogPostsController < ApplicationController

  before_filter :find_all_blog_posts, :find_all_blog_categories
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @blogs in the line below:
    present(@page)
  end

  def show
    @blog_post = BlogPost.live.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @blogs in the line below:
    present(@page)
  end

protected

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
