class BlogPostsController < ApplicationController

  before_filter :find_all_blog_posts
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
    @blog_posts = BlogPost.live
  end

  def find_page
    @page = Page.find_by_link_url("/blogs")
  end

end
