require 'spec_helper'

module Refinery
  module Blog
    describe Post do
      let(:post) { FactoryGirl.create(:blog_post) }

      describe "validations" do
        it "requires title" do
          FactoryGirl.build(:blog_post, :title => "").should_not be_valid
        end

        it "won't allow duplicate titles" do
          FactoryGirl.build(:blog_post, :title => post.title).should_not be_valid
        end

        it "requires body" do
          FactoryGirl.build(:blog_post, :body => nil).should_not be_valid
        end
      end

      describe "comments association" do

        it "have a comments attribute" do
          post.should respond_to(:comments)
        end

        it "destroys associated comments" do
          FactoryGirl.create(:blog_comment, :blog_post_id => post.id)
          post.destroy
          Blog::Comment.where(:blog_post_id => post.id).should be_empty
        end
      end

      describe "categories association" do
        it "have categories attribute" do
          post.should respond_to(:categories)
        end
      end

      describe "tags" do
        it "acts as taggable" do
          post.should respond_to(:tag_list)

          #the factory has default tags, including 'chicago'
          post.tag_list.should include("chicago")
        end
      end

      describe "authors" do
        it "are authored" do
          described_class.instance_methods.map(&:to_sym).should include(:author)
        end
      end

      describe "by_month" do
        before do
          @post1 = FactoryGirl.create(:blog_post, :published_at => Date.new(2011, 3, 11))
          @post2 = FactoryGirl.create(:blog_post, :published_at => Date.new(2011, 3, 12))

          #2 months before
          FactoryGirl.create(:blog_post, :published_at => Date.new(2011, 1, 10))
        end

        it "returns all posts from specified month" do
          #check for this month
          date = "03/2011"
          described_class.by_month(Time.parse(date)).count.should be == 2
          described_class.by_month(Time.parse(date)).should == [@post2, @post1]
        end
      end

      describe ".published_dates_older_than" do
        before do
          @post1 = FactoryGirl.create(:blog_post, :published_at => Time.utc(2012, 05, 01, 15, 20))
          @post2 = FactoryGirl.create(:blog_post, :published_at => Time.utc(2012, 05, 01, 15, 30))
          FactoryGirl.create(:blog_post, :published_at => Time.now)
        end

        it "returns all published dates older than the argument" do
          expected = [@post2.published_at, @post1.published_at]

          described_class.published_dates_older_than(5.minutes.ago).should eq(expected)
        end
      end

      describe "live" do
        before do
          @post1 = FactoryGirl.create(:blog_post, :published_at => Time.now.advance(:minutes => -2))
          @post2 = FactoryGirl.create(:blog_post, :published_at => Time.now.advance(:minutes => -1))
          FactoryGirl.create(:blog_post, :draft => true)
          FactoryGirl.create(:blog_post, :published_at => Time.now + 1.minute)
        end

        it "returns all posts which aren't in draft and pub date isn't in future" do
          described_class.live.count.should be == 2
          described_class.live.should == [@post2, @post1]
        end
      end

      describe "uncategorized" do
        before do
          @uncategorized_post = FactoryGirl.create(:blog_post)
          @categorized_post = FactoryGirl.create(:blog_post)

          @categorized_post.categories << FactoryGirl.create(:blog_category)
        end

        it "returns uncategorized posts if they exist" do
          described_class.uncategorized.should include @uncategorized_post
          described_class.uncategorized.should_not include @categorized_post
        end
      end

      describe "#live?" do
        it "returns true if post is not in draft and it's published" do
          Factory.build(:blog_post).should be_live
        end

        it "returns false if post is in draft" do
          Factory.build(:blog_post, :draft => true).should_not be_live
        end

        it "returns false if post pub date is in future" do
          Factory.build(:blog_post, :published_at => Time.now.advance(:minutes => 1)).should_not be_live
        end
      end

      describe "#next" do
        before do
          FactoryGirl.create(:blog_post, :published_at => Time.now.advance(:days => -1))
          @post = FactoryGirl.create(:blog_post)
        end

        it "returns next article when called on current article" do
          described_class.last.next.should == @post
        end
      end

      describe "#prev" do
        before do
          FactoryGirl.create(:blog_post)
          @post = FactoryGirl.create(:blog_post, :published_at => Time.now.advance(:days => -1))
        end

        it "returns previous article when called on current article" do
          described_class.first.prev.should == @post
        end
      end

      describe ".comments_allowed?" do
        context "with Refinery::Setting comments_allowed set to true" do
          before do
            Refinery::Setting.set(:comments_allowed, { :scoping => 'blog', :value => true })
          end

          it "should be true" do
            described_class.comments_allowed?.should be_true
          end
        end

        context "with Refinery::Setting comments_allowed set to false" do
          before do
            Refinery::Setting.set(:comments_allowed, { :scoping => 'blog', :value => false })
          end

          it "should be false" do
            described_class.comments_allowed?.should be_false
          end
        end
      end

      describe "custom teasers" do
        it "should allow a custom teaser" do
          FactoryGirl.create(:blog_post, :custom_teaser => 'This is some custom content').should be_valid
        end
      end

      describe ".teasers_enabled?" do
        context "with Refinery::Setting teasers_enabled set to true" do
          before do
            Refinery::Setting.set(:teasers_enabled, { :scoping => 'blog', :value => true })
          end

          it "should be true" do
            described_class.teasers_enabled?.should be_true
          end
        end

        context "with Refinery::Setting teasers_enabled set to false" do
          before do
            Refinery::Setting.set(:teasers_enabled, { :scoping => 'blog', :value => false })
          end

          it "should be false" do
            described_class.teasers_enabled?.should be_false
          end
        end
      end
      
      describe "source url" do
        it "should allow a source url and title" do
          p = FactoryGirl.create(:blog_post, :source_url => 'google.com', :source_url_title => 'author')
          p.should be_valid
          p.source_url.should include('google')
          p.source_url_title.should include('author')
        end
      end
      
      describe ".validate_source_url?" do
        context "with Refinery::Blog.validate_source_url set to true" do
          before do
            Refinery::Blog.validate_source_url = true
          end  
          it "should have canonical url" do
            p = FactoryGirl.create(:blog_post, :source_url => 'google.com', :source_url_title => 'google')
            p.source_url.should include('www')
          end
        end
        context "with Refinery::Blog.validate_source_url set to false" do
          before do
            Refinery::Blog.validate_source_url = false
          end
          it "should have original url" do
            p = FactoryGirl.create(:blog_post, :source_url => 'google.com', :source_url_title => 'google')
            p.source_url.should_not include('www')
          end
        end
      end
      
    end
  end
end
