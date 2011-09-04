require "spec_helper"

module Refinery
  describe "BlogPosts" do
    login_refinery_user
  
    context "when has blog posts" do    
      let!(:blog_post) { FactoryGirl.create(:blog_post, :title => "Refinery CMS blog post") }
    
      it "should display blog post" do
        visit blog_post_path(blog_post)
        
        page.should have_content(blog_post.title)
      end
    
      it "should display the blog rss feed" do
        get blog_rss_feed_path
        
        response.should be_success
        response.content_type.should eq("application/rss+xml")
      end
    end
      
    describe "list tagged posts" do    
      context "when has tagged blog posts" do      
        before(:each) do
          @tag_name = "chicago"
          @blog_post = FactoryGirl.create(:blog_post,
                                          :title => "I Love my city",
                                          :tag_list => @tag_name)
          @tag = ::Refinery::BlogPost.tag_counts_on(:tags).first          
        end
      
        it "should have one tagged post" do
          visit tagged_posts_path(@tag.id, @tag_name.parameterize)
          
          page.should have_content(@tag_name)
          page.should have_content(@blog_post.title)
        end
      end
    end
    
    describe "#show" do
      context "when has no comments" do
        let(:blog_post) { FactoryGirl.create(:blog_post) }
        
        it "should display the blog post" do
          visit blog_post_path(blog_post)
      
          page.should have_content(blog_post.title)
          page.should have_content(blog_post.body)
        end
      end
      
      context "when has approved comments" do
        let(:approved_comment) { FactoryGirl.create(:approved_comment) }
        
        it "should display the comments" do
          visit blog_post_path(approved_comment.post)
          
          page.should have_content(approved_comment.body)
          page.should have_content("Posted by #{approved_comment.name}")
        end
      end
      
      context "when has rejected comments" do
        let(:rejected_comment) { FactoryGirl.create(:rejected_comment) }
        
        it "should not display the comments" do          
          visit blog_post_path(rejected_comment.post)
          
          page.should_not have_content(rejected_comment.body)
        end
      end
      
      context "when has new comments" do
        let(:blog_comment) { FactoryGirl.create(:blog_comment) }
        
        it "should not display the comments" do
          visit blog_post_path(blog_comment.post)
          
          page.should_not have_content(blog_comment.body)
        end
      end
    end
  end
end
