require 'spec_helper'

describe BlogEditorHelper do
  describe "#use_textile?" do
    context "use_textile_for_blog_posting setting does not exist" do
      it "returns false" do
        use_textile?.should be_false
      end
    end
    context "use_textile_for_blog_posting setting does exist and is false" do
      it "returns false" do
        RefinerySetting.create(:name => "use_textile_for_blog_posting", :value => false, :scoping => "blog")
        use_textile?.should be_false
      end
    end
    
    context "use_textile_for_blog_posting setting does exist and is true" do
      it "returns true" do
        RefinerySetting.create(:name => "use_textile_for_blog_posting", :value => true, :scoping => "blog")
        use_textile?.should be_true
      end
    end
  end
end