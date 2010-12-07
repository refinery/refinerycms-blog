require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe BlogCategory do
  describe "validations" do
    before(:each) do
      @attr = { :title => "RefineryCMS" }
    end

    it "requires title" do
      BlogCategory.new(@attr.merge(:title => "")).should_not be_valid
    end

    it "won't allow duplicate titles" do
      BlogCategory.create!(@attr)
      BlogCategory.new(@attr).should_not be_valid
    end
  end

  describe "blog posts association" do
    it "have a posts attribute" do
      BlogCategory.new.should respond_to(:posts)
    end
  end

  describe "#post_count" do
    it "returns post count in category" do
      Factory(:post, :categories => [Factory(:blog_category)])
      Factory(:post, :categories => [Factory(:blog_category)])
      BlogCategory.first.post_count.should == 2
    end
  end
end
