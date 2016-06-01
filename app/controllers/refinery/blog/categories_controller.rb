module Refinery
  module Blog
    class CategoriesController < BlogController

      def show
        @category = Refinery::Blog::Category.friendly.find(params[:id])
        @posts = @category.posts.live.newest_first.uniq.includes(:comments, :categories).with_globalize.page(params[:page])
      end

    end
  end
end
