require 'spec_helper'

module Refinery
  module Blog
    describe Category, type: :model do
      let(:category) { FactoryGirl.create(:blog_category) }

      describe "validations" do
        it "requires title" do
          expect(FactoryGirl.build(:blog_category, :title => "")).not_to be_valid
        end

        it "won't allow duplicate titles" do
          expect(FactoryGirl.build(:blog_category, :title => category.title)).not_to be_valid
        end
      end

      describe "blog posts association" do
        it "has a posts attribute" do
          expect(category).to respond_to(:posts)
        end

        it "returns posts by published_at date in descending order" do
          first_post = category.posts.create!({ title: "Breaking News: Joe Sak is hot stuff you guys!!",
                                                body: "True story.",
                                                published_at: Time.now.yesterday,
                                                username: "John Doe" })

          latest_post = category.posts.create!({ title: "parndt is p. okay",
                                                 body: "For a Kiwi.",
                                                 published_at: Time.now,
                                                 username: "John Doe" })

          expect(category.posts.newest_first.first).to eq(latest_post)
        end

      end

      describe "#post_count" do
        it "returns post count in category" do
          2.times do
            category.posts << FactoryGirl.create(:blog_post)
          end
          expect(category.post_count).to eq(2)
        end
      end
    end
  end
end
