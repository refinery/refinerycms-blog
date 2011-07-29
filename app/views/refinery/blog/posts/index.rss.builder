xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title ::Refinery::Setting.find_or_set(:site_name, "Company Name")
    xml.description ::Refinery::Setting.find_or_set(:site_name, "Company Name") + " Blog Posts"
    xml.link main_app.blog_root_url

    @blog_posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link main_app.blog_post_url(post)
      end
    end
  end
end