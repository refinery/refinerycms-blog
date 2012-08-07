module Refinery
  module Blog
    class AuthorsController < BlogController

      def show
        @author = Refinery::User.find(params[:user])
        @posts = Refinery::Blog::Post.where(:user_id => @author.id).live.includes(:comments, :categories).page(params[:page])
      end

    end
  end
end
