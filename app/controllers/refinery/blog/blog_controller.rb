module Refinery
  module Blog
    class BlogController < ::ApplicationController

      include Refinery::Blog::ControllerHelper

      helper :'refinery/blog/posts'
      before_filter :find_page, :find_all_blog_categories

      protected

        def find_page
          @page = Refinery::Page.find_by(:link_url => Refinery::Blog.page_url)
        end
    end
  end
end
