require "spec_helper"

describe "blog categories" do
  login_refinery_user
  
  before(:each) do
    @blog_post = Factory(:blog_post, :title => "Refinery CMS blog post")
    @blog_category = Factory(:blog_category, :title => "Video Games")
    @blog_post.categories << @blog_category
    @blog_post.save!
  end

  context "has posts" do
    it "displays category's blog posts" do
      visit blog_category_path(@blog_category)
      page.should have_content("Refinery CMS blog post")
      page.should have_content("Video Games")
    end
  end
end
