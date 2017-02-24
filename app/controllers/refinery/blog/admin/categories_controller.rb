module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                :include => [:translations],
                :order => 'title ASC'

        private

        def category_params
          params.require(:category).permit(:title, :cat_type, :value)
        end
      end
    end
  end
end
