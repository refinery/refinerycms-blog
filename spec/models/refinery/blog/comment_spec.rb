require 'spec_helper'

module Refinery
  module Blog
    describe Comment, type: :model do
      context "wiring up" do
        let(:comment) { FactoryGirl.create(:blog_comment) }

        it "saves" do
          expect(comment).not_to be_nil
        end

        it "has a blog post" do
          expect(comment.post).not_to be_nil
        end
      end
    end
  end
end
