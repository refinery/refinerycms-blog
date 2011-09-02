require "spec_helper"

module Refinery
  describe "BlogPosts" do
    login_refinery_user
  
    context "when has blog posts" do    
      let(:blog_post) { FactoryGirl.create(:blog_post, :title => "Refinery CMS blog post") }
    
      it "should display blog post" do
        visit blog_post_path(blog_post)
        page.should have_content("Refinery CMS blog post")
      end
    
      it "should display the blog rss feed" do
        get blog_rss_feed_path
        response.should be_success
        response.content_type.should eq("application/rss+xml")
      end
    end
  
    describe "list tagged posts" do    
      context "when has tagged blog posts" do      
        before(:each) do
          @tag_name = "chicago"
          @blog_post = FactoryGirl.create(:blog_post,
                                      :title => "I Love my city",
                                      :tag_list => @tag_name)
          tag = ::Refinery::BlogPost.tag_counts_on(:tags).first
          visit tagged_posts_path(tag.id, @tag_name.parameterize)
        end
      
        it "should have one tagged post" do
          page.should have_content(@tag_name)
          page.should have_content(@blog_post.title)
        end
      end
    end
  end
end
