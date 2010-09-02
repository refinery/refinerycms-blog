class Admin::Blog::CommentsController < Admin::BaseController

  crudify :blog_comment,
          :title_attribute => :name,
          :order => 'created_at DESC'

  def index
    @blog_comments = BlogComment.unmoderated
    render :action => 'index'
  end

  def approved
    unless params[:id].present?
      @blog_comments = BlogComment.approved
      render :action => 'index'
    else
      @blog_comment = BlogComment.find(params[:id])
      @blog_comment.approve!
      flash[:notice] = t('admin.blog.comments.approved', :author => @blog_comment.name)
      redirect_to :action => params[:return_to] || 'index'
    end
  end

  def rejected
    unless params[:id].present?
      @blog_comments = BlogComment.rejected
      render :action => 'index'
    else
      @blog_comment = BlogComment.find(params[:id])
      @blog_comment.reject!
      flash[:notice] = t('admin.blog.comments.rejected', :author => @blog_comment.name)
      redirect_to :action => params[:return_to] || 'index'
    end
  end

end
