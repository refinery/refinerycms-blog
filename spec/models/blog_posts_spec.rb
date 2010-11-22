require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

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