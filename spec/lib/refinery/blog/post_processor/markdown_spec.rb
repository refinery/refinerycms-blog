require 'spec_helper'

describe Refinery::Blog::PostProcessor::Markdown do
  context "#process" do
    it "should return html for markdown markup" do
      Refinery::Blog::PostProcessor::Markdown.process("Markdown Foo\n============").should == "<h1>Markdown Foo</h1>\n"
    end
  end
end