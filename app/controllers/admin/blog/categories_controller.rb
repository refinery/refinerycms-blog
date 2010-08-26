class Admin::Blog::CategoriesController < Admin::BaseController

  crudify :blog_category,
          :title_attribute => :title,
          :order => 'title ASC'

end
