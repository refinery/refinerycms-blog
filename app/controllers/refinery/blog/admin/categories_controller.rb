module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                :order => 'title ASC'

        private

        def category_params
          params.require(:category).permit(:title)
        end
      end
    end
  end
end
