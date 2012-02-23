module Refinery
  module Blog
    module PostsHelper
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
           :length => Refinery::Blog.post_teaser_length,
           :preserve_html_tags => true
          }).html_safe
        end
      end

      def blog_archive_widget(dates=blog_archive_dates)
        ArchiveWidget.new(dates, self).display
      end

      def blog_archive_dates(cutoff=Time.now.beginning_of_month)
        Refinery::Blog::Post.published_dates_older_than(cutoff)
      end

      class ArchiveWidget
        delegate :t, :link_to, :refinery, :render, :to => :view_context
        attr_reader :view_context

        def initialize(dates, view_context, cutoff=3.years.ago.end_of_year)
          @recent_dates, @old_dates = dates.sort_by {|date| -date.to_i }.
            partition {|date| date > cutoff }

          @view_context = view_context
        end

        def recent_links
          @recent_dates.group_by {|date| [date.year, date.month] }.
            map {|(year, month), dates| recent_link(year, month, dates.count) }
        end

        def recent_link(year, month, count)
          link_to "#{t("date.month_names")[month]} #{year} (#{count})",
            refinery.blog_archive_posts_path(:year => year, :month => month)
        end

        def old_links
          @old_dates.group_by {|date| date.year }.
            map {|year, dates| old_link(year, dates.size) }
        end

        def old_link(year, count)
          link_to "#{year} (#{count})", refinery.blog_archive_posts_path(:year => year)
        end

        def links
          recent_links + old_links
        end

        def display
          return "" if links.empty?
          render "refinery/blog/widgets/blog_archive", :links => links
        end
      end
    end
  end
end
