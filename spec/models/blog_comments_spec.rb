require 'spec_helper'

describe BlogComment do
  it "initializes" do
    blog = BlogComment.new
    blog.should_not be_nil
  end
end