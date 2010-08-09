require 'spec_helper'

describe BlogPost do
  context "wiring up" do

      before(:each) do
        @post = Factory(:post)
      end

      it "saves to the database" do
        @post.should_not be_nil
      end

    end
end