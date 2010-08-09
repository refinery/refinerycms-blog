class Admin::BlogPostsController < Admin::BaseController

  crudify :blog_post, :title_attribute => :title, :order => 'created_at DESC'

end
