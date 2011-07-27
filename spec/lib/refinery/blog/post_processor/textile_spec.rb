require 'spec_helper'

describe Refinery::Blog::PostProcessor::Textile do
  context "#process" do
    it "should return html for textile markup" do
      Refinery::Blog::PostProcessor::Textile.process("h1. Textile Foo").should == "<h1>Textile Foo</h1>"
    end
  end
end
