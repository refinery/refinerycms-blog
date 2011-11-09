module Refinery
  module Blog
    class CategoriesController < BaseController

      def show
        @blog_category = Refinery::Blog::Category.find(params[:id])
        @blog_posts = @blog_category.posts.live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
