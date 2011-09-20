module Refinery
  module Blog
    class CategoriesController < BaseController

      def show
        @category = Refinery::BlogCategory.find(params[:id])
        @blog_posts = @category.posts.live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
