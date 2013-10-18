require 'spec_helper'
module Refinery
  module Blog
    describe ControllerHelper do
      describe "#find_tags" do
        let(:tags) { helper.find_tags }

        context "with draft posts" do
          let!(:blog_post) { FactoryGirl.create(:blog_post, :draft => true, :tag_list => "first, second" ) }
          it "does not return tags" do
            tags.should be_empty
          end
        end

        context "with live posts" do
          let!(:blog_post) { FactoryGirl.create(:blog_post, :tag_list => "first, second" ) }

          it "does not return tags" do
            tags.should_not be_empty
          end
        end
      end
    end
  end
end
