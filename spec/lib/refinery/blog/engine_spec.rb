require 'spec_helper'

module Refinery
  module Blog
    describe Engine do
      describe "plugin activity" do
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
