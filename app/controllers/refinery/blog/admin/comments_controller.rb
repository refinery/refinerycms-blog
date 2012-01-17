module Refinery
  module Blog
    module Admin
      class CommentsController < ::Refinery::AdminController
        
        cache_sweeper Refinery::BlogSweeper

        crudify :'refinery/blog/comment',
                :title_attribute => :name,
                :order => 'published_at DESC'

        def index
          @comments = Refinery::Blog::Comment.unmoderated.page(params[:page])
          
          render :action => 'index'
        end

        def approved
          unless params[:id].present?
            @comments = Refinery::Blog::Comment.approved.page(params[:page])
            
            render :action => 'index'
          else
            @comment = Refinery::Blog::Comment.find(params[:id])
            @comment.approve!
            flash[:notice] = t('approved', :scope => 'refinery.blog.admin.comments', :author => @comment.name)
            
            redirect_to main_app.url_for(:action => params[:return_to] || 'index')
          end
        end

        def rejected
          unless params[:id].present?
            @comments = Refinery::Blog::Comment.rejected.page(params[:page])
            
            render :action => 'index'
          else
            @comment = Refinery::Blog::Comment.find(params[:id])
            @comment.reject!
            flash[:notice] = t('rejected', :scope => 'refinery.blog.admin.comments', :author => @comment.name)
            
            redirect_to main_app.url_for(:action => params[:return_to] || 'index')
          end
        end

      end
    end
  end
end
