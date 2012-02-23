module Refinery
  module Blog
    module Admin
      class SettingsController < ::Refinery::AdminController

        def notification_recipients
          @recipients = Refinery::Blog::Comment::Notification.recipients

          if request.post?
            Refinery::Blog::Comment::Notification.recipients = params[:recipients]
            flash[:notice] = t('updated', :scope => 'refinery.blog.admin.settings.notification_recipients',
                               :recipients => Refinery::Blog::Comment::Notification.recipients)
            unless request.xhr? or from_dialog?
              redirect_back_or_default(refinery.blog_admin_posts_path)
            else
              render :text => "<script type='text/javascript'>parent.window.location = '#{refinery.blog_admin_posts_path}';</script>",
                     :layout => false
            end
          end
        end

        def moderation
          enabled = Refinery::Blog::Comment::Moderation.toggle!
          unless request.xhr?
            redirect_back_or_default(refinery.blog_admin_posts_path)
          else
            render :json => {:enabled => enabled},
                   :layout => false
          end
        end

        def comments
          enabled = Refinery::Blog::Comment.toggle!
          unless request.xhr?
            redirect_back_or_default(refinery.blog_admin_posts_path)
          else
            render :json => {:enabled => enabled},
                   :layout => false
          end
        end

        def teasers
          enabled = Refinery::Blog::Post.teaser_enabled_toggle!
          unless request.xhr?
            redirect_back_or_default(refinery.blog_admin_posts_path)
          else
            render :json => {:enabled => enabled},
                   :layout => false
          end
        end

      end
    end
  end
end