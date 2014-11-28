module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                  :order => 'lft ASC, title ASC',
                  :include => [ :children],
                   :paging => !Refinery::Blog.category_orderable
                   
        def children
          @category = find_category
          render :layout => false
        end
        
        protected

        def after_update_positions
          find_all_categories
          render :partial => '/refinery/blog/admin/categories/sortable_list' and return
        end
      
        def find_category
          @category = Category.find_by_path_or_id!(params[:path], params[:id])
        end
        alias_method :category, :find_category
        
        def category_params
          params.require(:category).permit(:title)
        end
      end
    end
  end
end
