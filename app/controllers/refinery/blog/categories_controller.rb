module Refinery
  module Blog
    class CategoriesController < BlogController

      def show
        @category = Refinery::BlogCategory.find(params[:id])
        @blog_posts = @category.posts.live.includes(:comments, :categories).paginate({
          :page => params[:page],
          :per_page => Refinery::Setting.find_or_set(:blog_posts_per_page, 10)
        })
      end

    end
  end
end
