module Refinery
  module Blog
    class CategoriesController < BlogController

      def show
        @category = Refinery::Blog::Category.where(:id => params[:id], :blog_id => @blog.id)
        @posts = @category.posts.live(@category.blog).includes(:comments, :categories).with_globalize.page(params[:page])
      end

    end
  end
end
