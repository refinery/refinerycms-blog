module Refinery
  class BlogController < ::ApplicationController

    helper :'refinery/blog_posts'
    before_filter :find_page, :find_all_blog_categories

    protected

    def find_page
      @page = Refinery::Page.find_by_link_url("/blog")
    end

    def find_all_blog_categories
      @blog_categories = Refinery::BlogCategory.all
    end

  end
end
