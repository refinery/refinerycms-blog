class Admin::Blog::CommentsController < Admin::BaseController

  crudify :blog_comment, :title_attribute => :name, :order => 'created_at DESC'

  def approved
    @blog_comments = BlogComment.approved
    render :action => 'index'
  end

  def rejected
    @blog_comments = BlogComment.rejected
    render :action => 'index'
  end

end
