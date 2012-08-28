require 'spec_helper'

module Refinery
  module Blog
    describe Blog do
      let(:blog) { FactoryGirl.create(:blog) }

      describe "validations" do
        subject do
          FactoryGirl.create(:blog,
                             :name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:name) { should == "Refinery CMS" }
      end

      describe 'post association' do
        it 'have posts attribute' do
          blog.should respond_to(:posts)
        end

        it 'destroys associated posts' do
          FactoryGirl.create(:blog_post, :blog_id => blog.id)
          blog.destroy
          ::Refinery::Blog::Post.where(:blog_id => blog.id).should be_empty
        end
      end

      describe 'category association' do
        it 'have category attribute' do
          blog.should respond_to(:categories)
        end

        it 'destroys associated categories' do
          FactoryGirl.create(:blog_category, :blog_id => blog.id)
          blog.destroy
          ::Refinery::Blog::Category.where(:blog_id => blog.id).should be_empty
        end
      end

      describe ".teasers_enabled?" do
        context "with Refinery::Setting teasers_enabled set to true" do
          before do
            Refinery::Setting.set(:teasers_enabled, { :scoping => blog.settings_scope, :value => true })
          end

          it "should be true" do
            blog.teasers_enabled?.should be_true
          end
        end

        context "with Refinery::Setting teasers_enabled set to false" do
          before do
            Refinery::Setting.set(:teasers_enabled, { :scoping => blog.settings_scope, :value => false })
          end

          it "should be false" do
            blog.teasers_enabled?.should be_false
          end
        end
      end

      describe ".comments_allowed?" do
        context "with Refinery::Setting comments_allowed set to true" do
          before do
            Refinery::Setting.set(:comments_allowed, { :scoping => blog.settings_scope, :value => true })
          end

          it "should be true" do
            blog.comments_allowed?.should be_true
          end
        end

        context "with Refinery::Setting comments_allowed set to false" do
          before do
            Refinery::Setting.set(:comments_allowed, { :scoping => blog.settings_scope, :value => false })
          end

          it "should be false" do
            blog.comments_allowed?.should be_false
          end
        end
      end

    end
  end
end
