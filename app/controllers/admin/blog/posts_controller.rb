class Admin::Blog::PostsController < Admin::BaseController

  crudify :blog_post, :title_attribute => :title, :order => 'created_at DESC'

end
