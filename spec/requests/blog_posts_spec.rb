require "spec_helper"

describe "blog" do
  before(:all) { Factory(:refinery_user) }

  it "displays the blog rss feed" do
    get blog_rss_feed_path
    response.should be_success
    response.content_type.should eq("application/rss+xml")
  end

  describe "posts" do
    let!(:blog_post) { Factory(:blog_post, :title => "Refinery CMS blog post") }

    context "has blog posts" do
      it "Displays blog post" do
        visit blog_post_path(blog_post)
        page.should have_content("Refinery CMS blog post")
      end
    end
  end
end
