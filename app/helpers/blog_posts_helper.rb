module BlogPostsHelper
  def blog_archive_list
    posts = BlogPost.select('published_at').all_previous
    return nil if posts.blank?
    html = '<section id="blog_archive_list"><h2>'
    html << t('blog.shared.archives')
    html << '</h2><nav><ul>'
    links = []

    posts.each do |e|
      links << e.published_at.strftime('%m/%Y')
    end
    links.uniq!
    links.each do |l|
      year = l.split('/')[1]
      month = l.split('/')[0]
      count = BlogPost.by_archive(Time.parse(l)).size
      text = t("date.month_names")[month.to_i] + " #{year} (#{count})"      
      html << "<li>"
      html << link_to(text, archive_blog_posts_path(:year => year, :month => month))
      html << "</li>"
    end
    html << '</ul></nav></section>'
    html.html_safe
  end

  def next_or_previous?(post)
    post.next.present? or post.prev.present?
  end
end
