require "spec_helper"

module Refinery
  module Blog
    describe PostsController, type: :controller do
      before do
        FactoryGirl.create(:blog_post, :title => "blogpost_one")
        FactoryGirl.create(:blog_post, :title => "blogpost_two")
        FactoryGirl.create(:blog_post, :title => "blogpost_three")
      end

      it "should not limit rss feed" do
        get :index, :format => :rss
        assigns[:posts].size.should == 3
      end

      it "should limit rss feed" do
        get :index, :format => :rss, :max_results => 2
        assigns[:posts].count.should == 2
      end
    end
  end
end

