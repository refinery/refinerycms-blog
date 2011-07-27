require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

module Refinery
  describe BlogPost do
    let(:blog_post ) { Factory.create(:blog_post) }

    describe "validations" do
      it "requires title" do
        Factory.build(:blog_post, :title => "").should_not be_valid
      end

      it "won't allow duplicate titles" do
        Factory.build(:blog_post, :title => blog_post.title).should_not be_valid
      end

      it "requires body" do
        Factory.build(:blog_post, :body => nil).should_not be_valid
      end
    end

    describe "comments association" do

      it "have a comments attribute" do
        blog_post.should respond_to(:comments)
      end

      it "destroys associated comments" do
        Factory.create(:blog_comment, :blog_post_id => blog_post.id)
        blog_post.destroy
        BlogComment.find_by_blog_post_id(blog_post.id).should == nil
      end
    end

    describe "categories association" do
      it "have categories attribute" do
        blog_post.should respond_to(:categories)
      end
    end

    describe "tags" do
      it "acts as taggable" do
        blog_post.should respond_to(:tag_list)

        #the factory has default tags, including 'chicago'
        blog_post.tag_list.should include("chicago")
      end
    end

    describe "authors" do
      it "are authored" do
        BlogPost.instance_methods.map(&:to_sym).should include(:author)
      end
    end

    describe "by_archive scope" do
      before do
        @blog_post1 = Factory.create(:blog_post, :published_at => Date.new(2011, 3, 11))
        @blog_post2 = Factory.create(:blog_post, :published_at => Date.new(2011, 3, 12))

        #2 months before
        Factory.create(:blog_post, :published_at => Date.new(2011, 1, 10))
      end

      it "returns all posts from specified month" do
        #check for this month
        date = "03/2011"
        BlogPost.by_archive(Time.parse(date)).count.should be == 2
        BlogPost.by_archive(Time.parse(date)).should == [@blog_post2, @blog_post1]
      end
    end

    describe "all_previous scope" do
      before do
        @blog_post1 = Factory.create(:blog_post, :published_at => Time.now - 2.months)
        @blog_post2 = Factory.create(:blog_post, :published_at => Time.now - 1.month)
        Factory.create(:blog_post, :published_at => Time.now)
      end

      it "returns all posts from previous months" do
        BlogPost.all_previous.count.should be == 2
        BlogPost.all_previous.should == [@blog_post2, @blog_post1]
      end
    end

    describe "live scope" do
      before do
        @blog_post1 = Factory.create(:blog_post, :published_at => Time.now.advance(:minutes => -2))
        @blog_post2 = Factory.create(:blog_post, :published_at => Time.now.advance(:minutes => -1))
        Factory.create(:blog_post, :draft => true)
        Factory.create(:blog_post, :published_at => Time.now + 1.minute)
      end

      it "returns all posts which aren't in draft and pub date isn't in future" do
        BlogPost.live.count.should be == 2
        BlogPost.live.should == [@blog_post2, @blog_post1]
      end
    end

    describe "uncategorized scope" do
      before do
        @uncategorized_blog_post = Factory.create(:blog_post)
        @categorized_blog_post = Factory.create(:blog_post)

        @categorized_blog_post.categories << Factory.create(:blog_category)
      end

      it "returns uncategorized posts if they exist" do
        BlogPost.uncategorized.should include @uncategorized_blog_post
        BlogPost.uncategorized.should_not include @categorized_blog_post
      end
    end

    describe "#live?" do
      it "returns true if post is not in draft and it's published" do
        Factory.create(:blog_post).live?.should be_true
      end

      it "returns false if post is in draft" do
        Factory.create(:blog_post, :draft => true).live?.should be_false
      end

      it "returns false if post pub date is in future" do
        Factory.create(:blog_post, :published_at => Time.now.advance(:minutes => 1)).live?.should be_false
      end
    end

    describe "#next" do
      before do
        Factory.create(:blog_post, :published_at => Time.now.advance(:minutes => -1))
        @blog_post = Factory.create(:blog_post)
      end

      it "returns next article when called on current article" do
        BlogPost.last.next.should == @blog_post
      end
    end

    describe "#prev" do
      before do
        Factory.create(:blog_post)
        @blog_post = Factory.create(:blog_post, :published_at => Time.now.advance(:minutes => -1))
      end

      it "returns previous article when called on current article" do
        BlogPost.first.prev.should == @blog_post
      end
    end

    describe "#category_ids=" do
      before do
        @cat1 = Factory.create(:blog_category, :id => 1)
        @cat2 = Factory.create(:blog_category, :id => 2)
        @cat3 = Factory.create(:blog_category, :id => 3)
        blog_post.category_ids = [1,2,"","",3]
      end

      it "rejects blank category ids" do
        blog_post.categories.count.should == 3
      end

      it "returns array of categories based on given ids" do
        blog_post.categories.should == [@cat1, @cat2, @cat3]
      end
    end

    describe ".comments_allowed?" do
      context "with Refinery::Setting comments_allowed set to true" do
        before do
          Refinery::Setting.set(:comments_allowed, { :scoping => 'blog', :value => true })
        end

        it "should be true" do
          BlogPost.comments_allowed?.should be_true
        end
      end

      context "with Refinery::Setting comments_allowed set to false" do
        before do
          Refinery::Setting.set(:comments_allowed, { :scoping => 'blog', :value => false })
        end

        it "should be false" do
          BlogPost.comments_allowed?.should be_false
        end
      end
    end

    describe "custom teasers" do
      it "should allow a custom teaser" do
        Factory.create(:blog_post, :custom_teaser => 'This is some custom content').should be_valid
      end
    end

    describe ".teasers_enabled?" do
      context "with Refinery::Setting teasers_enabled set to true" do
        before do
          Refinery::Setting.set(:teasers_enabled, { :scoping => 'blog', :value => true })
        end

        it "should be true" do
          BlogPost.teasers_enabled?.should be_true
        end
      end

      context "with Refinery::Setting teasers_enabled set to false" do
        before do
          Refinery::Setting.set(:teasers_enabled, { :scoping => 'blog', :value => false })
        end

        it "should be false" do
          BlogPost.teasers_enabled?.should be_false
        end
      end

    end

  end
end
