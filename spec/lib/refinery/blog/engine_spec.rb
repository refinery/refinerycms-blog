require 'spec_helper'

module Refinery
  module Blog
    describe Engine do
      describe "plugin activity" do
        subject {Refinery::Plugins.registered.find_by_name("refinerycms_blog").activity}

        it { subject[0].class_name.should == 'Refinery::Blog::Blog'}
        it { subject[1].class_name.should == 'Refinery::Blog::Post'}
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
