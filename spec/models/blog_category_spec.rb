require 'spec_helper'
Dir[File.expand_path('../../../features/support/factories/*.rb', __FILE__)].each{|factory| require factory}

describe BlogCategory do
  before(:each) do
    @blog_category = Factory.create(:blog_category)
  end

  describe "validations" do
    it "requires title" do
      Factory.build(:blog_category, :title => "").should_not be_valid
    end

    it "won't allow duplicate titles" do
      Factory.build(:blog_category, :title => @blog_category.title).should_not be_valid
    end
  end

  describe "blog posts association" do
    it "has a posts attribute" do
      @blog_category.should respond_to(:posts)
    end

    it "returns posts by published_at date in descending order" do
      first_post = @blog_category.posts.create!({ :title => "Breaking News: Joe Sak is hot stuff you guys!!", :body => "True story.", :published_at => Time.now.yesterday })
      latest_post = @blog_category.posts.create!({ :title => "parndt is p. okay", :body => "For a Kiwi.", :published_at => Time.now })

      @blog_category.posts.first.should == latest_post
    end

  end

  describe "#post_count" do
    it "returns post count in category" do
      2.times do
        @blog_category.posts << Factory.create(:blog_post)
      end
      @blog_category.post_count.should == 2
    end
  end
end
