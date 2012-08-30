module Refinery
  module Blog
    module Admin
      class CommentsController < ::Refinery::AdminController

        crudify :'refinery/blog/comment',
                :title_attribute => :name,
                :order => 'published_at DESC'

        before_filter :find_blog, :only => [:index, :approved, :rejected]

        def index
          @comments = Refinery::Blog::Comment.for_blog(@blog).unmoderated.page(params[:page])

          render :index
        end

        def approved
          @comments = Refinery::Blog::Comment.for_blog(@blog).approved.page(params[:page])

          render :index
        end

        def approve
          @comment = Refinery::Blog::Comment.find(params[:id])
          @comment.approve!
          flash[:notice] = t('approved', :scope => 'refinery.blog.admin.comments', :author => @comment.name)

          redirect_to refinery.blog_admin_blog_comments_path(@comment.blog)
        end

        def rejected
          @comments = Refinery::Blog::Comment.for_blog(@blog).rejected.page(params[:page])

          render :index
        end

        def reject
          @comment = Refinery::Blog::Comment.find(params[:id])
          @comment.reject!
          flash[:notice] = t('rejected', :scope => 'refinery.blog.admin.comments', :author => @comment.name)

          redirect_to refinery.blog_admin_blog_comments_path(@comment.blog)
        end

        protected

        def find_blog
          @blog = Refinery::Blog::Blog.find params[:blog_id]
        end
        
      end
    end
  end
end
