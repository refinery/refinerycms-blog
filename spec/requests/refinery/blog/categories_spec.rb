require "spec_helper"

module Refinery
  describe "BlogCategories" do
    refinery_login_with :refinery_user
    
    context "has one category and post" do
      before(:each) do
        post = Globalize.with_locale(:en) do
          FactoryGirl.create(:blog_post, :title => "Refinery CMS blog post")
        end
        @category = Globalize.with_locale(:en) do
          FactoryGirl.create(:blog_category, :title => "Video Games")
        end
        post.categories << @category
        post.save!
      end

      describe "show categories blog posts" do
        it "should displays categories blog posts" do
          visit refinery.blog_category_path(@category)
          page.should have_content("Refinery CMS blog post")
          page.should have_content("Video Games")
        end
      end
    end
  end
end
