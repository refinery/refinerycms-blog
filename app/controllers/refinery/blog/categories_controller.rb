module Refinery
  module Blog
    class CategoriesController < BlogController

      def show
        @category = Refinery::Blog::Category.friendly.find(params[:id])
        @posts = @category.posts.live.includes(:comments, :categories).with_globalize.page(params[:page])
      end

    end
  end
end
