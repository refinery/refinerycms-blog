require 'spec_helper'

module Refinery
  module Blog
    describe Engine do
      describe "plugin activity" do
        let(:activity) do
          Refinery::Plugins.registered.find_by_name("refinerycms_blog").activity.first
        end

        it "sets the correct path for activity entries" do
          activity.url.should eq("edit_refinery_blog_admin_post_path")
        end
      end

      describe ".load_seed" do
        it "is idempotent" do
          Engine.load_seed
          Engine.load_seed

          Refinery::Page.where(:link_url => '/blog').count.should eq(1)
        end
      end
    end
  end
end
