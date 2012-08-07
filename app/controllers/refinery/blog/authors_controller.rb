module Refinery
  module Blog
    class AuthorsController < BlogController

      def show
        @author = Refinery::User.find(params[:id])
        @posts = Refinery::Blog::Post.where(:user_id => @author.id).live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
