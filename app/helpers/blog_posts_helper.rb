module BlogPostsHelper
  def blog_archive_list
    posts = BlogPost.select('published_at').all_previous
    return nil if posts.blank?
    html = '<section id="blog_archive_list"><h2>'
    html << t('archives', :scope => 'blog.shared')
    html << '</h2><nav><ul>'
    links = []
    super_old_links = []

    posts.each do |e|
      if e.published_at >= Time.now.end_of_year.advance(:years => -3)
        links << e.published_at.strftime('%m/%Y') 
      else
        super_old_links << e.published_at.strftime('01/%Y')
      end
    end
    links.uniq!
    super_old_links.uniq!
    links.each do |l|
      year = l.split('/')[1]
      month = l.split('/')[0]
      count = BlogPost.by_archive(Time.parse(l)).size
      text = t("date.month_names")[month.to_i] + " #{year} (#{count})"      
      html << "<li>"
      html << link_to(text, archive_blog_posts_path(:year => year, :month => month))
      html << "</li>"
    end
    super_old_links.each do |l|
      year = l.split('/')[1]
      count = BlogPost.by_year(Time.parse(l)).size
      text = "#{year} (#{count})"
      html << "<li>"
      html << link_to(text, archive_blog_posts_path(:year => year))
      html << "</li>"
    end
    html << '</ul></nav></section>'
    html.html_safe
  end

  def next_or_previous?(post)
    post.next.present? or post.prev.present?
  end

  def blog_post_teaser(post)
    if post.respond_to?(:custom_teaser) && post.custom_teaser.present?
     post.custom_teaser.html_safe
    else
     truncate(post.body, {
       :length => RefinerySetting.find_or_set(:blog_post_teaser_length, 250),
       :preserve_html_tags => true
      }).html_safe
    end
  end
end
