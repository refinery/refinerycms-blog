require 'spec_helper'

describe Refinery::Blog::PostProcessor::Wymeditor do
  context "#process" do
    it "should return html for html markup" do
      Refinery::Blog::PostProcessor::Wymeditor.process("<h1>HTML Foo</h1>").should == "<h1>HTML Foo</h1>"
    end
  end
end