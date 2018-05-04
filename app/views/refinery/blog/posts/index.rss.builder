xml.instruct! :xml, :version => "1.0"
xml.rss version: "2.0", 'xmlns:atom': 'http://www.w3.org/2005/Atom', 'xmlns:media': 'http://search.yahoo.com/mrss/' do
  xml.channel do
    xml.title Refinery::Core.site_name
    xml.description Refinery::Core.site_name + " Blog Posts"
    xml.link refinery.blog_root_url
    xml.tag! 'atom:link', href: refinery.blog_rss_feed_url, rel: 'self', type: 'application/rss+xml'

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description blog_post_teaser(post)
        xml.category post.categories.map {|x| x.title }.join('/') if  post.categories.length > 0
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link refinery.blog_post_url(post)
        xml.guid refinery.blog_post_url(post)
        post.images.each do |image|
          xml.media :content, url: refinery.root_url + image.url, medium: 'image'
        end if post.respond_to?(:images)
      end
    end
  end
end