require 'spec_helper'

describe BlogCategory do
  it "initializes" do
    blog = BlogCategory.new
    blog.should_not be_nil
  end
end