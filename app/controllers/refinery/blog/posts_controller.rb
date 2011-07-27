module Refinery
  module Blog
    class PostsController < BlogController

      before_filter :find_all_blog_posts, :except => [:archive]
      before_filter :find_blog_post, :only => [:show, :comment, :update_nav]
      before_filter :find_tags

      respond_to :html, :js, :rss

      def index
        # Rss feeders are greedy. Let's give them every blog post instead of paginating.
        (@blog_posts = Refinery::BlogPost.live.includes(:comments, :categories).all) if request.format.rss? 
        respond_with (@blog_posts) do |format|
          format.html
          format.rss
        end
      end

      def show
        @blog_comment = Refinery::BlogComment.new

        respond_with (@blog_post) do |format|
          format.html { present(@blog_post) }
          format.js { render :partial => 'post', :layout => false }
        end
      end

      def comment
        if (@blog_comment = @blog_post.comments.create(params[:blog_comment])).valid?
          if Refinery::BlogComment::Moderation.enabled? or @blog_comment.ham?
            begin
              Refinery::Blog::CommentMailer.notification(@blog_comment, request).deliver
            rescue
              logger.warn "There was an error delivering a blog comment notification.\n#{$!}\n"
            end
          end

          if Refinery::BlogComment::Moderation.enabled?
            flash[:notice] = t('thank_you_moderated', :scope => 'blog.posts.comments')
            redirect_to blog_post_url(params[:id])
          else
            flash[:notice] = t('thank_you', :scope => 'blog.posts.comments')
            redirect_to blog_post_url(params[:id],
                                      :anchor => "comment-#{@blog_comment.to_param}")
          end
        else
          render :action => 'show'
        end
      end

      def archive
        if params[:month].present?
          date = "#{params[:month]}/#{params[:year]}"
          @archive_date = Time.parse(date)
          @date_title = @archive_date.strftime('%B %Y')
          @blog_posts = BlogPost.live.by_archive(@archive_date).paginate({
            :page => params[:page],
            :per_page => Refinery::Setting.find_or_set(:blog_posts_per_page, 10)
          })
        else
          date = "01/#{params[:year]}"
          @archive_date = Time.parse(date)
          @date_title = @archive_date.strftime('%Y')
          @blog_posts = Refinery::live.by_year(@archive_date).paginate({
            :page => params[:page],
            :per_page => Refinery::Setting.find_or_set(:blog_posts_per_page, 10)
          })
        end
        respond_with (@blog_posts)
      end

      def tagged
        @tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
        @tag_name = @tag.name
        @blog_posts = Refinery::BlogPost.tagged_with(@tag_name).paginate({
          :page => params[:page],
          :per_page => Refinery::Setting.find_or_set(:blog_posts_per_page, 10)
        })
      end

    protected

      def find_blog_post
        unless (@blog_post = Refinery::BlogPost.find(params[:id])).try(:live?)
          if refinery_user? and current_user.authorized_plugins.include?("refinerycms_blog")
            @blog_post = Refinery::BlogPost.find(params[:id])
          else
            error_404
          end
        end
      end

      def find_all_blog_posts
        @blog_posts = Refinery::BlogPost.live.includes(:comments, :categories).paginate({
          :page => params[:page],
          :per_page => Refinery::Setting.find_or_set(:blog_posts_per_page, 10)
        })
      end

      def find_tags
        @tags = Refinery::BlogPost.tag_counts_on(:tags)
      end

    end
  end
end
