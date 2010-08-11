class Admin::Blog::CommentsController < Admin::BaseController

  crudify :blog_comment, :title_attribute => :name, :order => 'created_at DESC'

  def index
    @blog_comments = BlogComment.unmoderated
    render :action => 'index'
  end

  def approved
    @blog_comments = BlogComment.approved
    render :action => 'index'
  end

  def rejected
    @blog_comments = BlogComment.rejected
    render :action => 'index'
  end

end
