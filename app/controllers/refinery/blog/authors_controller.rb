module Refinery
  module Blog
    class AuthorsController < BlogController

      def show
        @author = Refinery::User.find(params[:id])
        @posts = @author.posts.live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
