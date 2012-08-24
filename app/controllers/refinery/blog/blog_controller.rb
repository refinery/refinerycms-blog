module Refinery
  module Blog
    class BlogController < ::ApplicationController

      include ControllerHelper

      helper :'refinery/blog/posts'
      before_filter :find_page, :find_blog, :find_all_blog_categories

      protected

      def find_page
        @page = Refinery::Page.find_by_link_url("/blogs")
      end

      def find_blog
        @blog = Refinery::Blog::Blog.find_by_slug(params[:blog_id])
      end

    end
  end
end
