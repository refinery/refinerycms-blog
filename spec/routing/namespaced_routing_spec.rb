require 'spec_helper'

describe "default path" do
  it "routes /blog/posts/1 to the Blog::Post controller" do
    get('/blog/posts/1').
      should route_to(
        :controller => "refinery/blog/posts",
        :action => "show",
        :id => "1",
      )
  end
end

describe "custom path" do
  before do
    @original_mount_path = Refinery::Blog.mount_path
    Refinery::Blog.mount_path = "/foo"
    Rails.application.routes_reloader.reload!
  end

  after do
    Refinery::Blog.mount_path = @original_mount_path
    Rails.application.routes_reloader.reload!
  end

  it "routes /foo/posts/1 to the Blog::Post controller" do
    {:get => '/foo/posts/1'}.
      should route_to(
        :controller => "refinery/blog/posts",
        :action => "show",
        :id => "1",
      )
  end
end
