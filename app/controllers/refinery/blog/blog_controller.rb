module Refinery
  module Blog
    class BlogController < ::ApplicationController

      include ControllerHelper

      helper :'refinery/blog/posts'
      before_filter :find_blog, :find_page, :find_all_blog_categories

      protected

      def find_page
        @page = Refinery::Page.find_by_link_url("/blogs/#{@blog.slug}")
      end

      def find_blog
        @blog = Refinery::Blog::Blog.find_by_slug_or_id(params[:blog_id])
        error_404 unless @blog && @blog.translated_locales.include?(Globalize.locale)
      end

    end
  end
end
