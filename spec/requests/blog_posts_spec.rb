require "spec_helper"

describe "blog posts" do
  before(:each) do
    Factory.create(:refinery_user)
  end
  
  context "when has blog posts" do    
    let(:blog_post) { Factory(:blog_post, :title => "Refinery CMS blog post") }
    
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
end
