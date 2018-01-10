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
        expect(assigns[:posts].size).to eq(3)
      end

      it "should limit rss feed" do
        get :index, :format => :rss, params: { :max_results => 2 }
        expect(assigns[:posts].count).to eq(2)
      end
    end
  end
end

