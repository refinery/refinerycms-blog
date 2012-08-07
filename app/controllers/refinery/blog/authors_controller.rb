module Refinery
  module Blog
    class AuthorsController < BlogController

      def show
        @author = Refinery::Blog::Author.find(params[:id])
        @posts = @author.posts.live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
