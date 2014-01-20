module Refinery
  module Blog
    module ControllerHelper

      protected

        def find_blog_post
          @post = all_blog_posts.friendly.find(params[:id])
          unless @post.try(:live?)
            if refinery_user? && current_refinery_user.authorized_plugins.include?("refinerycms_blog")
              @post = Post.friendly.find(params[:id])
            else
              error_404
            end
          end
        end

        def find_all_blog_posts
          @posts = all_blog_posts.live
        end

        def find_tags
          @tags = Refinery::Blog::Post.live.tag_counts_on(:tags)
        end

        def find_all_blog_categories
          @categories = Refinery::Blog::Category.translated
        end
    end
  end
end
