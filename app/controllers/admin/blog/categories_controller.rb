module Admin
  module Blog
    class CategoriesController < Admin::BaseController

      crudify :blog_category,
              :title_attribute => :title,
              :order => 'title ASC'

    end
  end
end
