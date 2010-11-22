module NavigationHelpers
  module Refinery
    module Blog
      def path_to(page_name)
        case page_name
        when /the list of blog posts/
          admin_blog_posts_path
        when /the new blog posts? form/
          new_admin_blog_post_path
        else
          begin
            if page_name =~ /the blog post titled "?([^\"]*)"?/ and (page = BlogPost.find_by_title($1)).present?
              self.url_for(page.url)
            else
              nil
            end
          rescue
            nil
          end
        end
      end
    end
  end
end
