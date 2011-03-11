require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe BlogPost do
  describe "validations" do
    before(:each) do
      @attr = { :title => "RefineryCMS", :body => "Some random text ..." }
    end

    it "requires title" do
      BlogPost.new(@attr.merge(:title => "")).should_not be_valid
    end

    it "won't allow duplicate titles" do
      BlogPost.create!(@attr)
      BlogPost.new(@attr).should_not be_valid
    end

    it "requires body" do
      BlogPost.new(@attr.merge(:body => nil)).should_not be_valid
    end
  end

  describe "comments association" do
    before(:each) do
      @blog_post = Factory(:post)
    end

    it "have a comments attribute" do
      @blog_post.should respond_to(:comments)
    end

    it "destroys associated comments" do
      Factory(:blog_comment, :blog_post_id => @blog_post)
      @blog_post.destroy
      BlogComment.find_by_blog_post_id(@blog_post).should be_nil
    end
  end

  describe "categories association" do
    before(:each) do
      @blog_post = Factory(:post)
    end

    it "have categories attribute" do
      @blog_post.should respond_to(:categories)
    end
  end
  
  describe "tags" do
    it "acts as taggable" do
      Factory(:post).should respond_to(:tag_list)
    end
  end
  
  describe "authors" do
    it "are authored" do
      BlogPost.instance_methods.map(&:to_sym).include? :author
    end
  end

  describe "by_archive scope" do
    it "returns all posts from specified month" do
      blog_post1 = Factory(:post, :published_at => Time.now.advance(:minutes => -2))
      blog_post2 = Factory(:post, :published_at => Time.now.advance(:minutes => -1))
      Factory(:post, :published_at => Time.now - 2.months)
      date = "#{Time.now.month}/#{Time.now.year}"
      BlogPost.by_archive(Time.parse(date)).count.should == 2
      BlogPost.by_archive(Time.parse(date)).should == [blog_post2, blog_post1]
    end
  end

  describe "all_previous scope" do
    it "returns all posts from previous months" do
      blog_post1 = Factory(:post, :published_at => Time.now.advance(:months => -2))
      blog_post2 = Factory(:post, :published_at => Time.now.advance(:months => -1))
      Factory(:post, :published_at => Time.now)
      BlogPost.all_previous.count.should == 2
      BlogPost.all_previous.should == [blog_post2, blog_post1]
    end
  end

  describe "live scope" do
    it "returns all posts which aren't in draft and pub date isn't in future" do
      blog_post1 = Factory(:post, :published_at => Time.now.advance(:minutes => -2))
      blog_post2 = Factory(:post, :published_at => Time.now.advance(:minutes => -1))
      Factory(:post, :draft => true)
      Factory(:post, :published_at => Time.now + 1.minute)
      BlogPost.live.count.should == 2
      BlogPost.live.should == [blog_post2, blog_post1]
    end
  end

  describe "next scope" do
    it "returns next article based on given article" do
      blog_post1 = Factory(:post, :published_at => Time.now.advance(:minutes => -1))
      blog_post2 = Factory(:post)
      BlogPost.next(blog_post1).should == [blog_post2]
    end
  end

  describe "previous scope" do
    it "returns previous article based on given article" do
      blog_post1 = Factory(:post, :published_at => Time.now.advance(:minutes => -1))
      blog_post2 = Factory(:post)
      BlogPost.previous(blog_post2).should == [blog_post1]
    end
  end

  describe "uncategorized scope" do
    it "returns uncategorized posts if they exist" do
      uncategorized_blog_post = Factory(:post)
      categorized_blog_post = Factory(:post)

      categorized_blog_post.categories << Factory(:blog_category)

      BlogPost.uncategorized.should include uncategorized_blog_post
      BlogPost.uncategorized.should_not include categorized_blog_post
    end
  end

  describe "#live?" do
    it "returns true if post is not in draft and it's published" do
      Factory(:post).live?.should be_true
    end

    it "returns false if post is in draft" do
      Factory(:post, :draft => true).live?.should be_false
    end

    it "returns false if post pub date is in future" do
      Factory(:post, :published_at => Time.now.advance(:minutes => 1)).live?.should be_false
    end
  end

  describe "#next" do
    it "returns next article when called on current article" do
      Factory(:post, :published_at => Time.now.advance(:minutes => -1))
      blog_post = Factory(:post)
      blog_posts = BlogPost.all
      blog_posts.last.next.should == blog_post
    end
  end

  describe "#prev" do
    it "returns previous article when called on current article" do
      Factory(:post)
      blog_post = Factory(:post, :published_at => Time.now.advance(:minutes => -1))
      blog_posts = BlogPost.all
      blog_posts.first.prev.should == blog_post
    end
  end

  describe "#category_ids=" do
    before(:each) do
      @blog_post = Factory(:post)
      @cat1 = Factory(:blog_category, :id => 1)
      @cat2 = Factory(:blog_category, :id => 2)
      @cat3 = Factory(:blog_category, :id => 3)
      @blog_post.category_ids = [1,2,"","",3]
    end

    it "rejects blank category ids" do
      @blog_post.categories.count.should == 3
    end

    it "returns array of categories based on given ids" do
      @blog_post.categories.should == [@cat1, @cat2, @cat3]
    end
  end

  describe ".comments_allowed?" do
    it "returns true if comments_allowed setting is set to true" do
      BlogPost.comments_allowed?.should be_true
    end

    it "returns false if comments_allowed setting is set to false" do
      RefinerySetting.set(:comments_allowed, {:scoping => 'blog', :value => false})
      BlogPost.comments_allowed?.should be_false
    end
  end
end
