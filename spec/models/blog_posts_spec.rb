require 'spec_helper'

describe BlogPost do
  it "initializes" do
    blog = BlogPost.new
    blog.should_not be_nil
  end
end