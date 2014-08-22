require 'spec_helper'

module Refinery
  module Blog
    describe Category, type: :model do
      let(:category) { FactoryGirl.create(:blog_category) }
      let(:refinery_user) { FactoryGirl.create(:refinery_user) }

      describe "validations" do
        it "requires title" do
          FactoryGirl.build(:blog_category, :title => "").should_not be_valid
        end

        it "won't allow duplicate titles" do
          FactoryGirl.build(:blog_category, :title => category.title).should_not be_valid
        end
      end

      describe "blog posts association" do
        it "has a posts attribute" do
          category.should respond_to(:posts)
        end

        it "returns posts by published_at date in descending order" do
          first_post = category.posts.create!({ :title => "Breaking News: Joe Sak is hot stuff you guys!!",
                                                :body => "True story.",
                                                :published_at => Time.now.yesterday,
                                                :author => refinery_user })

          latest_post = category.posts.create!({ :title => "parndt is p. okay",
                                                 :body => "For a Kiwi.",
                                                 :published_at => Time.now,
                                                 :author => refinery_user })

          category.posts.newest_first.first.should == latest_post
        end

      end

      describe "#post_count" do
        it "returns post count in category" do
          2.times do
            category.posts << FactoryGirl.create(:blog_post)
          end
          category.post_count.should == 2
        end
      end
    end
  end
end
