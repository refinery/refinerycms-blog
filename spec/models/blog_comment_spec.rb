require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe BlogComment do

  context "wiring up" do

    before(:each) do
      @comment = Factory(:blog_comment)
    end

    it "saves" do
      @comment.should_not be_nil
    end

    it "has a blog post" do
      @comment.post.should_not be_nil
    end

  end
end
