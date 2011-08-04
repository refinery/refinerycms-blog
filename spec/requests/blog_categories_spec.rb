require "spec_helper"

describe "blog categories" do
  login_refinery_user
    
  context "has one category and post" do
    before(:each) do
      @blog_post = Factory.create(:blog_post, :title => "Refinery CMS blog post")
      @blog_category = Factory.create(:blog_category, :title => "Video Games")
      @blog_post.categories << @blog_category
      @blog_post.save!
    end
        
    describe "show categories blog posts" do
      before(:each) { visit blog_category_path(@blog_category) }
      
      it "should displays categories blog posts" do
        page.should have_content("Refinery CMS blog post")
        page.should have_content("Video Games")
      end
    end
  end
end
