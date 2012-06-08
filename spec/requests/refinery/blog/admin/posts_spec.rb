# encoding: utf-8
require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe Post do
        refinery_login_with :refinery_user

        let!(:blog_category) { FactoryGirl.create(:blog_category, :title => "Video Games") }

        context "when no blog posts" do
          before(:each) { subject.class.destroy_all }

          describe "blog post listing" do
            before(:each) { visit refinery.blog_admin_posts_path }

            it "invites to create new post" do
              page.should have_content("There are no Blog Posts yet. Click \"Create new post\" to add your first blog post.")
            end
          end

          describe "new blog post form" do
            before(:each) do
              visit refinery.blog_admin_posts_path
              click_link "Create new post"
            end

            it "should have Tags" do
              page.should have_content("Tags")
            end

            it "should have Video Games" do
              page.should have_content(blog_category.title)
            end

            describe "create blog post" do
              before(:each) do
                fill_in "Title", :with => "This is my blog post"
                fill_in "post_body", :with => "And I love it"
                check blog_category.title
                click_button "Save"
              end

              it "should succeed" do
                page.should have_content("was successfully added.")
              end

              it "should be the only blog post" do
                subject.class.all.size.should eq(1)
              end

              it "should belong to me" do
                subject.class.first.author.should eq(::Refinery::User.last)
              end

              it "should save categories" do
                subject.class.last.categories.count.should eq(1)
                subject.class.last.categories.first.title.should eq(blog_category.title)
              end
            end

            describe "create blog post with tags" do
              before(:each) do
                @tag_list = "chicago, bikes, beers, babes"
                fill_in "Title", :with => "This is a tagged blog post"
                fill_in "post_body", :with => "And I also love it"
                fill_in "Tags", :with => @tag_list
                click_button "Save"
              end

              it "should succeed" do
                page.should have_content("was successfully added.")
              end

              it "should be the only blog post" do
                subject.class.all.size.should eq(1)
              end

              it "should have the specified tags" do
                subject.class.last.tag_list.sort.should eq(@tag_list.split(', ').sort)
              end
            end
          end
        end

        context "when has blog posts" do
          let!(:blog_post) { FactoryGirl.create(:blog_post) }

          describe "blog post listing" do
            before(:each) { visit refinery.blog_admin_posts_path }

            describe "edit blog post" do
              it "should succeed" do
                page.should have_content(blog_post.title)

                click_link("Edit this blog post")
                current_path.should == refinery.edit_blog_admin_post_path(blog_post)

                fill_in "Title", :with => "hax0r"
                click_button "Save"

                page.should_not have_content(blog_post.title)
                page.should have_content("'hax0r' was successfully updated.")
              end
            end

            describe "deleting blog post" do
              it "should succeed" do
                page.should have_content(blog_post.title)

                click_link "Remove this blog post forever"

                page.should have_content("'#{blog_post.title}' was successfully removed.")
              end
            end

            describe "view live" do
              it "redirects to blog post in the frontend" do
                click_link "View this blog post live"

                current_path.should == refinery.blog_post_path(blog_post)
                page.should have_content(blog_post.title)
              end
            end
          end

          context "when uncategorized post" do
            it "shows up in the list" do
              visit refinery.uncategorized_blog_admin_posts_path
              page.should have_content(blog_post.title)
            end
          end

          context "when categorized post" do
            it "won't show up in the list" do
              blog_post.categories << blog_category
              blog_post.save!

              visit refinery.uncategorized_blog_admin_posts_path
              page.should_not have_content(blog_post.title)
            end
          end
        end

        context "with multiple users" do
          let!(:other_guy) { Factory(:refinery_user, :username => "Other Guy") }

          describe "create blog post with alternate author" do
            before(:each) do
              visit refinery.blog_admin_posts_path
              click_link "Create new post"

              fill_in "Title", :with => "This is some other guy's blog post"
              fill_in "post_body", :with => "I totally didn't write it."

              click_link "Advanced Options"

              select other_guy.username, :from => "Author"

              click_button "Save"
            end

            it "should succeed" do
              page.should have_content("was successfully added.")
            end

            it "belongs to another user" do
              subject.class.last.author.should eq(other_guy)
            end
          end
        end

        context "with translations" do
          before(:each) do
            Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])
            blog_page = Factory.create(:page, :link_url => "/blog", :title => "Blog")
            Globalize.with_locale(:ru) do
              blog_page.title = 'блог'
              blog_page.save
            end
            visit refinery.blog_admin_posts_path
          end

          describe "add a blog post with title for default locale" do
            before do
              click_link "Create new post"
              fill_in "Title", with: "Post"
              fill_in "post_body", with: "One post in my blog"
              click_button "Save"
              @p = Refinery::Blog::Post.find_by_title("Post")
            end

            it "succeeds" do
              page.should have_content("'Post' was successfully added.")
              Refinery::Blog::Post.count.should eq(1)
            end

            it "shows locale flag for post" do

              within "#post_#{@p.id}" do
                page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
              end
            end

            it "shows up in blog page for default locale" do
              visit refinery.blog_root_path
              page.should have_selector("#post_#{@p.id}")
            end

            it "does not show up in blog page for secondary locale" do
              visit refinery.blog_root_path(locale: :ru)
              page.should_not have_selector("#post_#{@p.id}")
              Globalize.locale = :en #reset locale to be sure next request will use :en locale for globalize
            end

          end

          describe "add a blog post with title only for secondary locale" do

            let(:ru_page_title) { 'Новости' }

            before do
              click_link "Create new post"
              within "#switch_locale_picker" do
                click_link "Ru"
              end
              fill_in "Title", with: ru_page_title
              fill_in "post_body", with: "One post in my blog"
              click_button "Save"
              @p = Refinery::Blog::Post.find_by_title("Новости")
            end

            it "succeeds" do
              page.should have_content("was successfully added.")
              Refinery::Blog::Post.count.should eq(1)
            end

            it "shows title in secondary locale" do
              within "#post_#{@p.id}" do
                page.should have_content(ru_page_title)
              end
            end

            it "shows locale flag for post" do
              within "#post_#{@p.id}" do
                page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
              end
            end

            it "does not show locale flag for primary locale" do
              within "#post_#{@p.id}" do
                page.should_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
              end
            end

            it "does not show up in blog page for default locale" do
              visit refinery.blog_root_path
              page.should_not have_selector("#post_#{@p.id}")
            end

            it "shows up in blog page for secondary locale" do
              visit refinery.blog_root_path(locale: :ru)
              page.should have_selector("#post_#{@p.id}")
              Globalize.locale = :en #reset locale to be sure next request will use :en locale for globalize
            end

          end


          context "with a blog post in both locales" do

            let!(:blog_post) do
              _blog_post = Globalize.with_locale(:en) { FactoryGirl.create(:blog_post, title: 'First Post') }
              Globalize.with_locale(:ru) do
                _blog_post.title = 'Домашняя страница'
                _blog_post.save
              end
              _blog_post
            end

            before(:each) do
              visit refinery.blog_admin_posts_path
            end

            it "shows both locale flags for post" do
              within "#post_#{blog_post.id}" do
                page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
                page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
              end
            end

            describe "edit the post in english" do
              it "succeeds" do

                within "#post_#{blog_post.id}" do
                  click_link("En")
                end
                current_path.should == refinery.edit_blog_admin_post_path(blog_post)
                fill_in "Title", with: "New Post Title"
                click_button "Save"

                page.should_not have_content(blog_post.title)
                page.should have_content("'New Post Title' was successfully updated.")
              end
            end

            describe "edit the post in secondary locale" do
              it "succeeds" do
                within "#post_#{blog_post.id}" do
                  click_link("Ru")
                end

                fill_in "Title", with: "Нов"
                click_button "Save"

                page.should_not have_content(blog_post.title)
                page.should have_content("'Нов' was successfully updated.")
              end
            end

          end
        end

      end
    end
  end
end
