module Refinery
  module Blog
    class AuthorsController < BlogController

      def show
        @author = Refinery::User.find(params[:id])
        @posts = Refinery::Blog::Post.where(:user_id => 0).live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
