module Refinery
  module Blog
    class AuthorsController < BlogController

      def show
        @posts = @author.posts.live.includes(:comments, :categories, :author => params[:id]).page(params[:page])
      end

    end
  end
end
