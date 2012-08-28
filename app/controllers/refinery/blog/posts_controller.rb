module Refinery
  module Blog
    class PostsController < BlogController

      before_filter :find_posts_for_blog, :except => [:archive]
      before_filter :find_blog_post, :only => [:show, :comment, :update_nav]
      before_filter :find_tags

      respond_to :html, :js, :rss

      def index
        # Rss feeders are greedy. Let's give them every blog post instead of paginating.
        (@posts = Post.live(@blog).includes(:comments, :categories).with_globalize) if request.format.rss?
        respond_with (@posts) do |format|
          format.html
          format.rss { render :layout => false }
        end
      end

      def show
        @comment = Comment.new
        @comment.post = @post

        @canonical = refinery.url_for(:locale => Refinery::I18n.current_frontend_locale) if canonical?

        @post.increment!(:access_count, 1)

        respond_with (@post) do |format|
          format.html { present(@post) }
          format.js { render :partial => 'post', :layout => false }
        end
      end

      def comment
        if (@comment = @post.comments.create(params[:comment])).valid?
          if @blog.comments_moderation_enabled? or @comment.ham?
            begin
              CommentMailer.notification(@comment, request).deliver
            rescue
              logger.warn "There was an error delivering a blog comment notification.\n#{$!}\n"
            end
          end

          if @blog.comments_moderation_enabled?
            flash[:notice] = t('thank_you_moderated', :scope => 'refinery.blog.posts.comments')
            redirect_to refinery.blog_post_url(params[:blog_id],
                                               params[:id])
          else
            flash[:notice] = t('thank_you', :scope => 'refinery.blog.posts.comments')
            redirect_to refinery.blog_post_url(params[:blog_id],
                                               params[:id],
                                               :anchor => "comment-#{@comment.to_param}")
          end
        else
          render :show
        end
      end

      def archive
        if params[:month].present?
          date = "#{params[:month]}/#{params[:year]}"
          @archive_date = Time.parse(date)
          @date_title = @archive_date.strftime('%B %Y')
          @posts = Post.live(@blog).by_month(@archive_date).page(params[:page])
        else
          date = "01/#{params[:year]}"
          @archive_date = Time.parse(date)
          @date_title = @archive_date.strftime('%Y')
          @posts = Post.live(@blog).by_year(@archive_date).page(params[:page])
        end
        respond_with (@posts)
      end

      def tagged
        @tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
        @tag_name = @tag.name
        @posts = Post.where(:blog_id => @blog.id).tagged_with(@tag_name).with_globalize.page(params[:page])
      end

      protected
      def find_posts_for_blog
        @posts = Refinery::Blog::Post.live(@blog).includes(:comments, :categories).with_globalize.page(params[:page])
      end

      def canonical?
        ::Refinery.i18n_enabled? && ::Refinery::I18n.default_frontend_locale != ::Refinery::I18n.current_frontend_locale
      end
    end
  end
end
