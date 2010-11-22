require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe BlogCategory do
  context "wiring up" do

    before(:each) do
      @category = Factory(:blog_category)
    end

    it "saves" do
      @category.should_not be_nil
    end

    it "has a blog post" do
      BlogPost.last.categories.should include(@category)
    end

  end

end
