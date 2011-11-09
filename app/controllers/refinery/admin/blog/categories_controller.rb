module Refinery
  module Admin
    module Blog
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                :title_attribute => :title,
                :order => 'title ASC'

      end
    end
  end
end
