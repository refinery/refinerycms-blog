require 'spec_helper'

module Refinery
  module Blog
    describe Engine do
      let(:activity) do
        Refinery::Plugins.registered.find_by_name("refinerycms_blog").activity.first
      end

      it "sets the correct path for activity entries" do
        activity.url.should eq("edit_refinery_admin_blog_posts_path")
      end
    end
  end
end
