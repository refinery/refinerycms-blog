require 'spec_helper'

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