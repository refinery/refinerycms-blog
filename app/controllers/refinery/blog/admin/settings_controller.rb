module Refinery
  module Blog
    module Admin
      class SettingsController < ::Refinery::AdminController

        before_filter :find_blog

        def notification_recipients
          @recipients = @blog.comments_notifications_recipients

          if request.post?
            @blog.comments_notifications_recipients = params[:recipients]
            flash[:notice] = t('updated', :scope => 'refinery.blog.admin.settings.notification_recipients',
                               :recipients => @blog.comments_notifications_recipients)
            unless request.xhr? or from_dialog?
              redirect_back_or_default(refinery.blog_admin_blog_posts_path(@blog))
            else
              render :text => "<script type='text/javascript'>parent.window.location = '#{refinery.blog_admin_blog_posts_path(@blog)}';</script>",
              :layout => false
            end
          end
        end

        def moderation
          enabled = @blog.comments_moderation_toggle!
          unless request.xhr?
            redirect_back_or_default(refinery.blog_admin_blog_posts_path(@blog))
          else
            render :json => {:enabled => enabled},
            :layout => false
          end
        end

        def comments
          enabled = @blog.comments_toggle!
          unless request.xhr?
            redirect_back_or_default(refinery.blog_admin_blog_posts_path(@blog))
          else
            render :json => {:enabled => enabled},
            :layout => false
          end
        end

        def teasers
          enabled = @blog.teaser_enabled_toggle!
          unless request.xhr?
            redirect_back_or_default(refinery.blog_admin_blog_posts_path(@blog))
          else
            render :json => {:enabled => enabled},
            :layout => false
          end
        end

        private

        def find_blog
          @blog = Refinery::Blog::Blog.find params[:blog_id]
        end

      end
    end
  end
end
