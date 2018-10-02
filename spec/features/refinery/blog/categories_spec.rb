require "spec_helper"

module Refinery
  module Blog
    describe Category, type: :feature do

      context "has one category and post" do
        before do
          post = Mobility.with_locale(:en) do
            FactoryBot.create(:blog_post, :title => "Refinery CMS blog post")
          end
          @category = Mobility.with_locale(:en) do
            FactoryBot.create(:blog_category, :title => "Video Games")
          end
          post.categories << @category
          post.save!
        end

        describe "show categories blog posts" do
          it "should displays categories blog posts" do
            visit refinery.blog_category_path(@category)
            expect(page).to have_content("Refinery CMS blog post")
            expect(page).to have_content("Video Games")
          end
        end
      end
    end
  end
end