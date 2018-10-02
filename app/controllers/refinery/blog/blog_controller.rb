module Refinery
  module Blog
    class BlogController < ::ApplicationController

      helper :'refinery/blog/posts'
      before_action :find_page, :find_all_blog_categories

      protected

      def find_all_blog_categories
        @categories = Refinery::Blog::Category.translated
      end

      def find_blog_post
        unless (@post = post_finder_scope.with_mobility.friendly.find(params[:id])).try(:live?)
          if current_refinery_user && current_refinery_user.has_plugin?("refinerycms_blog")
            @post = post_finder_scope.friendly.find(params[:id])
          else
            error_404
          end
        end
      end

      def find_all_blog_posts
        @posts = post_finder_scope.live.includes(
          :comments, :categories, :translations
        ).with_mobility.newest_first.page(params[:page])
      end

      def find_page
        @page = Refinery::Page.find_by(link_url: Refinery::Blog.page_url)
      end

      def find_tags
        @tags = post_finder_scope.live.tag_counts_on(:tags)
      end

      def post_finder_scope
        Refinery::Blog::Post
      end
    end
  end
end
