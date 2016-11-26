module Refinery
  module Blog
    module ControllerHelper

      protected

      def find_blog_post
        unless (@post = Refinery::Blog::Post.with_globalize.friendly.find(params[:id])).try(:live?)
          if current_refinery_user && current_refinery_user.has_plugin?("refinerycms_blog")
            @post = Refinery::Blog::Post.friendly.find(params[:id])
          else
            error_404
          end
        end
      end

      def find_all_blog_posts
        @posts = post_finder_scope.live.includes(
          :comments, :categories, :translations
        ).with_globalize.newest_first.page(params[:page])
      end

      def find_tags
        @tags = Refinery::Blog::Post.live.tag_counts_on(:tags)
      end

      def find_all_blog_categories
        @categories = Refinery::Blog::Category.translated
      end

      def post_finder_scope
        Refinery::Blog::Post
      end
    end
  end
end
