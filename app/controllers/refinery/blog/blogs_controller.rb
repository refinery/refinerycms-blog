module Refinery
  module Blog
    class BlogsController < ::ApplicationController

      before_filter :find_page

      def index
        @blogs = Refinery::Blog::Blog.page(params[:page])
      end

      def find_page
        @page = Refinery::Page.find_by_link_url("/blogs")
      end

    end
  end
end
