module Refinery
  module Admin
    module Blog
      class SettingsController < ::Refinery::AdminController

        def notification_recipients
          @recipients = Refinery::BlogComment::Notification.recipients

          if request.post?
            Refinery::BlogComment::Notification.recipients = params[:recipients]
            flash[:notice] = t('updated', :scope => 'admin.blog.settings.notification_recipients',
                               :recipients => Refinery::BlogComment::Notification.recipients)
            unless request.xhr? or from_dialog?
              redirect_back_or_default(admin_blog_posts_path)
            else
              render :text => "<script type='text/javascript'>parent.window.location = '#{admin_blog_posts_path}';</script>",
                     :layout => false
            end
          end
        end

        def moderation
          enabled = Refinery::BlogComment::Moderation.toggle!
          unless request.xhr?
            redirect_back_or_default(admin_blog_posts_path)
          else
            render :json => {:enabled => enabled},
                   :layout => false
          end
        end

        def comments
          enabled = Refinery::BlogComment.toggle!
          unless request.xhr?
            redirect_back_or_default(admin_blog_posts_path)
          else
            render :json => {:enabled => enabled},
                   :layout => false
          end
        end

        def teasers
          enabled = Refinery::BlogPost.teaser_enabled_toggle!
          unless request.xhr?
            redirect_back_or_default(admin_blog_posts_path)
          else
            render :json => {:enabled => enabled},
                   :layout => false
          end
        end

      end
    end
  end
end
