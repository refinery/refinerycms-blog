module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                :order => 'title ASC'

				def posts
					@category = Category.find(params[:id])
					@posts = @category.posts.page(params[:page])
				end

      end
    end
  end
end
