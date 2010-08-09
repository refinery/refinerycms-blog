class Admin::Blog::CategoriesController < Admin::BaseController

  crudify :blog_category, :title_attribute => :name, :order => 'created_at DESC'

end
