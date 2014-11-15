module Refinery
  module Blog
    class CategoriesController < Refinery::AdminController

      include ControllerHelper
      crudify :'refinery/blog/categories',
              :order => "lft ASC",
              :paging => false
              
      before_filter :find_all_categories, :only => [:index]
                      
      def show
        @category = Refinery::Blog::Category.friendly.find(params[:id])
        @posts = @category.posts.live.includes(:comments, :categories).with_globalize.page(params[:page])
      end

    end
  end
end
