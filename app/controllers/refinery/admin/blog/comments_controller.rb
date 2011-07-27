module Refinery
  module Admin
    module Blog
      class CommentsController < ::Admin::BaseController

        crudify :'refinery/blog_comment',
                :title_attribute => :name,
                :order => 'published_at DESC'

        def index
          @blog_comments = Refinery::BlogComment.unmoderated
          render :action => 'index'
        end

        def approved
          unless params[:id].present?
            @blog_comments = Refinery::BlogComment.approved
            render :action => 'index'
          else
            @blog_comment = Refinery::BlogComment.find(params[:id])
            @blog_comment.approve!
            flash[:notice] = t('approved', :scope => 'admin.blog.comments', :author => @blog_comment.name)
            redirect_to :action => params[:return_to] || 'index'
          end
        end

        def rejected
          unless params[:id].present?
            @blog_comments = Refinery::BlogComment.rejected
            render :action => 'index'
          else
            @blog_comment = Refinery::BlogComment.find(params[:id])
            @blog_comment.reject!
            flash[:notice] = t('rejected', :scope => 'admin.blog.comments', :author => @blog_comment.name)
            redirect_to :action => params[:return_to] || 'index'
          end
        end

      end
    end
  end
end
