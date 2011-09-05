require 'spec_helper'

module Refinery
  describe BlogComment do

    context "wiring up" do

      before(:each) do
        @comment = FactoryGirl.create(:blog_comment)
      end

      it "saves" do
        @comment.should_not be_nil
      end

      it "has a blog post" do
        @comment.post.should_not be_nil
      end

    end
  end
end
