class Admin::Blog::PostsController < Admin::BaseController

  crudify :blog_post,
          :title_attribute => :title,
          :order => 'published_at DESC'
          
  def uncategorized
    @blog_posts = BlogPost.uncategorized.paginate({
      :page => params[:page],
      :per_page => BlogPost.per_page
    })
  end

  before_filter :find_all_categories,
                :only => [:new, :edit, :create, :update]

protected
  def find_all_categories
    @blog_categories = BlogCategory.find(:all)
  end
end
