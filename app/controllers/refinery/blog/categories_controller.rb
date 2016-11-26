module Refinery
  module Blog
    class CategoriesController < BlogController

      before_action :find_category, :find_all_blog_posts, only: :show

      private

      def find_category
        @category = Refinery::Blog::Category.friendly.find(params[:id])
      end

      def post_finder_scope
        @category.posts
      end

    end
  end
end
