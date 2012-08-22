module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
        :order => 'title ASC',
        :redirect_to_url => 'refinery.blog_admin_blog_categories_path'

        before_filter :find_blog, :only => [:index, :new, :create]

        def new
          @category = Refinery::Blog::Category.new(:blog => @blog)
        end

        protected

        def find_blog
          @blog = Refinery::Blog::Blog.find params[:blog_id]
        end

      end
    end
  end
end
