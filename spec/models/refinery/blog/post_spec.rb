require 'spec_helper'

module Refinery
  module Blog
    describe Post, type: :model do
      let(:post) { FactoryGirl.create(:blog_post) }

      describe "validations" do
        it "requires title" do
          expect(FactoryGirl.build(:blog_post, :title => "")).not_to be_valid
        end

        it "won't allow duplicate titles" do
          expect(FactoryGirl.build(:blog_post, :title => post.title)).not_to be_valid
        end

        it "requires body" do
          expect(FactoryGirl.build(:blog_post, :body => nil)).not_to be_valid
        end
      end

      describe "comments association" do

        it "have a comments attribute" do
          expect(post).to respond_to(:comments)
        end

        it "destroys associated comments" do
          FactoryGirl.create(:blog_comment, :blog_post_id => post.id)
          post.destroy
          expect(Blog::Comment.where(:blog_post_id => post.id)).to be_empty
        end
      end

      describe "categories association" do
        it "have categories attribute" do
          expect(post).to respond_to(:categories)
        end
      end

      describe "tags" do
        it "acts as taggable" do
          expect(post).to respond_to(:tag_list)

          post.tag_list = "refinery, cms"
          post.save!

          expect(post.tag_list).to include("refinery")
        end
      end

      describe "authors" do
        before do
          allow(Refinery::Blog).to receive(:user_class).and_return("Refinery::Authentication::Devise::User")
        end

        let(:author) { mock_model(::Refinery::Blog.user_class, id: 1) }
        let(:blog_post) { FactoryGirl.create(:blog_post, author: author) }

        it "are authored" do
          expect(described_class.instance_methods.map(&:to_sym)).to include(:author)
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
          expect(described_class.by_month(Time.parse(date)).count).to eq(2)
          expect(described_class.by_month(Time.parse(date))).to eq([@post2, @post1])
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

          expect(described_class.published_dates_older_than(5.minutes.ago)).to eq(expected)
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
          live_posts = described_class.live
          expect(live_posts.count).to eq(2)
          expect(live_posts).to include(@post2)
          expect(live_posts).to include(@post1)
        end
      end

      describe "uncategorized" do
        before do
          @uncategorized_post = FactoryGirl.create(:blog_post)
          @categorized_post = FactoryGirl.create(:blog_post)

          @categorized_post.categories << FactoryGirl.create(:blog_category)
        end

        it "returns uncategorized posts if they exist" do
          expect(described_class.uncategorized).to include @uncategorized_post
          expect(described_class.uncategorized).not_to include @categorized_post
        end
      end

      describe "#live?" do
        it "returns true if post is not in draft and it's published" do
          expect(FactoryGirl.build(:blog_post)).to be_live
        end

        it "returns false if post is in draft" do
          expect(FactoryGirl.build(:blog_post, :draft => true)).not_to be_live
        end

        it "returns false if post pub date is in future" do
          expect(FactoryGirl.build(:blog_post, :published_at => Time.now.advance(:minutes => 1))).not_to be_live
        end
      end

      describe "#next" do
        before do
          FactoryGirl.create(:blog_post, :published_at => Time.now.advance(:days => -1))
          @post = FactoryGirl.create(:blog_post)
        end

        it "returns next article when called on current article" do
          expect(described_class.newest_first.last.next).to eq(@post)
        end
      end

      describe "#prev" do
        before do
          FactoryGirl.create(:blog_post)
          @post = FactoryGirl.create(:blog_post, :published_at => Time.now.advance(:days => -1))
        end

        it "returns previous article when called on current article" do
          expect(described_class.first.prev).to eq(@post)
        end
      end

      describe ".comments_allowed?" do
        context "with Refinery::Setting comments_allowed set to true" do
          before do
            Refinery::Setting.set(:comments_allowed, { :scoping => 'blog', :value => true })
          end

          it "should be true" do
            expect(described_class.comments_allowed?).to be_truthy
          end
        end

        context "with Refinery::Setting comments_allowed set to false" do
          before do
            Refinery::Setting.set(:comments_allowed, { :scoping => 'blog', :value => false })
          end

          it "should be false" do
            expect(described_class.comments_allowed?).to be_falsey
          end
        end
      end

      describe "custom teasers" do
        it "should allow a custom teaser" do
          expect(FactoryGirl.create(:blog_post, :custom_teaser => 'This is some custom content')).to be_valid
        end
      end

      describe ".teasers_enabled?" do
        context "with Refinery::Setting teasers_enabled set to true" do
          before do
            Refinery::Setting.set(:teasers_enabled, { :scoping => 'blog', :value => true })
          end

          it "should be true" do
            expect(described_class.teasers_enabled?).to be_truthy
          end
        end

        context "with Refinery::Setting teasers_enabled set to false" do
          before do
            Refinery::Setting.set(:teasers_enabled, { :scoping => 'blog', :value => false })
          end

          it "should be false" do
            expect(described_class.teasers_enabled?).to be_falsey
          end
        end
      end

      describe "source url" do
        it "should allow a source url and title" do
          p = FactoryGirl.create(:blog_post, :source_url => 'google.com', :source_url_title => 'author')
          expect(p).to be_valid
          expect(p.source_url).to include('google')
          expect(p.source_url_title).to include('author')
        end
      end

      describe ".validate_source_url?" do
        context "with Refinery::Blog.validate_source_url set to true" do
          before do
            Refinery::Blog.validate_source_url = true
          end
          it "should have canonical url" do
            expect_any_instance_of(UrlValidator).to receive(:resolve_redirects_verify_url).
                                      and_return('http://www.google.com')
            p = FactoryGirl.create(:blog_post, :source_url => 'google.com', :source_url_title => 'google')
            expect(p.source_url).to include('www')
          end
        end
        context "with Refinery::Blog.validate_source_url set to false" do
          before do
            Refinery::Blog.validate_source_url = false
          end
          it "should have original url" do
            p = FactoryGirl.create(:blog_post, :source_url => 'google.com', :source_url_title => 'google')
            expect(p.source_url).not_to include('www')
          end
        end
      end

      describe "#should_generate_new_friendly_id?" do
        context "when custom_url changes" do
          it "regenerates slug upon save" do
            post = FactoryGirl.create(:blog_post, :custom_url => "Test Url")

            post.custom_url = "Test Url 2"
            post.save!

            expect(post.slug).to eq("test-url-2")
          end
        end

        context "when title changes" do
          it "regenerates slug upon save" do
            post = FactoryGirl.create(:blog_post, :title => "Test Title")

            post.title = "Test Title 2"
            post.save!

            expect(post.slug).to eq("test-title-2")
          end
        end
      end

    end
  end
end
