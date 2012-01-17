module Refinery
  module Blog
    module PostsHelper
      def blog_archive_widget
        posts = Refinery::Blog::Post.select('published_at').all_previous
        return nil if posts.blank?

        render :partial => "/refinery/blog/widgets/blog_archive", :locals => { :posts => posts }
      end
      alias_method :blog_archive_list, :blog_archive_widget

      def next_or_previous?(post)
        post.next.present? or post.prev.present?
      end

      def blog_post_teaser_enabled?
        Refinery::Blog::Post.teasers_enabled?
      end

      def blog_post_teaser(post)
        if post.respond_to?(:custom_teaser) && post.custom_teaser.present?
         post.custom_teaser.html_safe
        else
         truncate(post.body, {
           :length => Refinery::Setting.find_or_set(:blog_post_teaser_length, 250),
           :preserve_html_tags => true
          }).html_safe
        end
      end

      def archive_link(post)
        if post.published_at >= Time.now.end_of_year.advance(:years => -3)
          post_date = post.published_at.strftime('%m/%Y')
          year = post_date.split('/')[1]
          month = post_date.split('/')[0]
          count = Blog::Post.by_archive(Time.parse(post_date)).size
          text = t("date.month_names")[month.to_i] + " #{year} (#{count})"

          link_to(text, main_app.refinery_blog_archive_posts_path(:year => year, :month => month))
        else
          post_date = post.published_at.strftime('01/%Y')
          year = post_date.split('/')[1]
          count = Refinery::Blog::Post.by_year(Time.parse(post_date)).size
          text = "#{year} (#{count})"

          link_to(text, main_app.refinery_blog_archive_posts_path(:year => year))
        end
      end
    end
  end
end
