require "spec_helper"

module Refinery
  describe "Blog::Posts" do
    refinery_login_with :refinery_user

    let!(:blog) { FactoryGirl.create(:blog) }

    describe 'multiblog' do
      let!(:blog_2) { FactoryGirl.create(:blog) }
      before {FactoryGirl.create(:page, :link_url => '/blogs', :title => 'Blogs') }

      it 'should display the correct blog' do
        visit "/blogs/#{blog.slug}"

        page.should have_content(blog.name)

        visit "/blogs/#{blog_2.slug}"

        page.should have_content(blog_2.name)
      end
    end

    context "when has blog posts" do
      let!(:blog_post) { Globalize.with_locale(:en) { FactoryGirl.create(:blog_post, :title => "Refinery CMS blog post", :blog => blog) } }

      it "should display blog post" do
        visit refinery.blog_post_path(blog, blog_post)

        page.should have_content(blog_post.title)
      end

      it "should display the blog rss feed" do
        get refinery.blog_rss_feed_path(blog)

        response.should be_success
        response.content_type.should eq("application/rss+xml")
      end

      describe "visit blog" do

        before(:each) do
          Factory.create(:page, :link_url => "/")
          Factory.create(:page, :link_url => "/blogs", :title => "Blogs")
        end

        it "shows blog link in menu" do
          visit "/"
          within "#menu" do
            page.should have_content("Blogs")
            page.should have_selector("a[href='/blogs']")
          end
        end

        it "shows blog posts" do
          visit refinery.blog_blog_path(blog)
          page.should have_content blog_post.title
        end

      end

    end

    describe "list tagged posts" do
      context "when has tagged blog posts" do
        before(:each) do
          @tag_name = "chicago"
          @post = FactoryGirl.create(:blog_post,
                                     :title => "I Love my city",
                                     :tag_list => @tag_name,
                                     :blog => blog)
          @tag = ::Refinery::Blog::Post.tag_counts_on(:tags).first
        end

        it "should have one tagged post" do
          visit refinery.blog_tagged_posts_path(blog, @tag.id, @tag_name.parameterize)

          page.should have_content(@tag_name)
          page.should have_content(@post.title)
        end

        describe 'multiblog' do
          let!(:blog_2) { FactoryGirl.create(:blog) }
          let!(:post_2) { FactoryGirl.create(:blog_post,
                                             :title => "I don't like my city so much",
                                             :tag_list => @tag_name,
                                             :blog => blog_2)}

          it 'should show the blog tagged posts only' do
            visit refinery.blog_tagged_posts_path(blog_2, @tag.id, @tag_name.parameterize)

            page.should have_content(@tag_name)
            page.should have_content(post_2.title)
            page.should_not have_content(@post.title)
          end
        end
      end
    end

    describe "#show" do
      let(:blog_post) { FactoryGirl.create(:blog_post, :blog => blog) }
      
      context "when has no comments" do
        it "should display the blog post" do
          visit refinery.blog_post_path(blog, blog_post)
          page.should have_content(blog_post.title)
          page.should have_content(blog_post.body)
        end
      end
      context "when has approved comments" do
        let(:approved_comment) { FactoryGirl.create(:approved_comment,
                                                    :post => blog_post) }

        it "should display the comments" do
          visit refinery.blog_post_path(blog, approved_comment.post)

          page.should have_content(approved_comment.body)
          page.should have_content("Posted by #{approved_comment.name}")
        end
      end
      context "when has rejected comments" do
        let(:rejected_comment) { FactoryGirl.create(:rejected_comment,
                                                    :post => blog_post) }

        it "should not display the comments" do
          visit refinery.blog_post_path(blog, rejected_comment.post)

          page.should_not have_content(rejected_comment.body)
        end
      end
      context "when has new comments" do
        let(:blog_comment) { FactoryGirl.create(:blog_comment,
                                                :post => blog_post) }

        it "should not display the comments" do
          visit refinery.blog_post_path(blog, blog_comment.post)

          page.should_not have_content(blog_comment.body)
        end
      end

      context "when posting comments" do
        let(:name) { "pete" }
        let(:email) { "pete@mcawesome.com" }
        let(:body) { "Witty comment." }

        before do
          visit refinery.blog_post_path(blog, blog_post)

          fill_in "Name", :with => name
          fill_in "Email", :with => email
          fill_in "Message", :with => body
          click_button "Send comment"
        end

        it "creates the comment" do
          comment = blog_post.reload.comments.last

          comment.name.should eq(name)
          comment.email.should eq(email)
          comment.body.should eq(body)
        end
      end

      context "post popular" do
        let(:blog_post) { FactoryGirl.create(:blog_post, :blog => blog) }
        let(:blog_post2) { FactoryGirl.create(:blog_post, :blog => blog) }

        before do
          visit refinery.blog_post_path(blog, blog_post)
        end

        it "should increment access count" do
          blog_post.reload.access_count.should eq(1)
          visit refinery.blog_post_path(blog, blog_post)
          blog_post.reload.access_count.should eq(2)
        end

        it "should be most popular" do
          Refinery::Blog::Post.popular(2).first.should eq(blog_post)
        end
      end

      context "post recent" do
        let!(:blog_post) { FactoryGirl.create(:blog_post, :published_at => Time.now - 5.minutes) }
        let!(:blog_post2) { FactoryGirl.create(:blog_post, :published_at => Time.now - 2.minutes) }

        it "should be the most recent" do
          Refinery::Blog::Post.recent(2).first.id.should eq(blog_post2.id)
        end
      end

    end

    describe "#show draft preview" do
      let(:blog_post) { FactoryGirl.create(:blog_post_draft,
                                           :blog => blog) }

      context "when logged in as admin" do
        it "should display the draft notification" do
          visit refinery.blog_post_path(blog, blog_post)

          page.should have_content('This page is NOT live for public viewing.')
        end
      end

      context "when not logged in as an admin" do
        before do
          visit refinery.logout_path
        end

        it "should not display the blog post" do
          visit refinery.blog_post_path(blog, blog_post)

          page.should have_content("The page you were looking for doesn't exist (404)")
        end
      end
    end
  end
end
