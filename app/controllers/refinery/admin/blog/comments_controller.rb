module Refinery
  module Admin
    module Blog
      class CommentsController < ::Refinery::AdminController
        
        cache_sweeper Refinery::BlogSweeper

        crudify :'refinery/blog/comment',
                :title_attribute => :name,
                :order => 'published_at DESC'

        def index
          @blog_comments = Refinery::Blog::Comment.unmoderated.page(params[:page])
          
          render :action => 'index'
        end

        def approved
          unless params[:id].present?
            @blog_comments = Refinery::Blog::Comment.approved.page(params[:page])
            
            render :action => 'index'
          else
            @blog_comment = Refinery::Blog::Comment.find(params[:id])
            @blog_comment.approve!
            flash[:notice] = t('approved', :scope => 'refinery.admin.blog.comments', :author => @blog_comment.name)
            
            redirect_to main_app.url_for(:action => params[:return_to] || 'index')
          end
        end

        def rejected
          unless params[:id].present?
            @blog_comments = Refinery::Blog::Comment.rejected.page(params[:page])
            
            render :action => 'index'
          else
            @blog_comment = Refinery::Blog::Comment.find(params[:id])
            @blog_comment.reject!
            flash[:notice] = t('rejected', :scope => 'refinery.admin.blog.comments', :author => @blog_comment.name)
            
            redirect_to main_app.url_for(:action => params[:return_to] || 'index')
          end
        end

      end
    end
  end
end
