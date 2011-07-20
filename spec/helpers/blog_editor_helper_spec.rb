require 'spec_helper'

describe BlogEditorHelper do
  before(:each) do
    RefinerySetting.where("name = 'blog_post_editor' and scoping = 'blog'").all.each { |r| r.destroy }
    RefinerySetting.rewrite_cache
  end
  
  context "#blog_post_editor" do
  
    context "blog_post_editor setting == wymeditor" do
      before(:each) do
       RefinerySetting.create(:name => :blog_post_editor, :value => "wymeditor", :scoping => "blog")
      end
      it "returns wymeditor" do
        blog_post_editor.should == "wymeditor"
      end
    end
  
    context "blog_post_editor setting == textile" do
      before(:each) do
        RefinerySetting.create(:name => :blog_post_editor, :value => "textile", :scoping => "blog")
      end
      it "returns textile" do
        blog_post_editor.should == "textile"
      end
    end
  
    context "blog_post_editor setting is unset" do
      it "sets the setting to wymeditor" do
        blog_post_editor
        RefinerySetting.get(:blog_post_editor, {:scoping => "blog"}).should == "wymeditor"
      end
      it "returns wymeditor" do
        blog_post_editor.should == "wymeditor"
      end
    end
  
    context "blog_post_editor setting has no corresponding PostProcessor class" do
      it "returns false" do
        RefinerySetting.create(:name => :blog_post_editor, :value => "foobarbazqux", :scoping => "blog")
        blog_post_editor.should == "wymeditor"
      end
    end
  
  end
  
  context "#markup_processor_for?(editor)" do
    context "when the requested PostProcessor class exists" do
      it "returns true" do
        markup_processor_for?("wymeditor").should == true
      end
    end
    context "when the requested PostProcessor class does not exist" do
      it "returns false" do
        markup_processor_for?("foobarbazqux")
      end
    end
    context "when the editor is nil" do
      it "returns false" do
        markup_processor_for?(nil)
      end
    end
  end
end
