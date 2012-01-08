require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe Post do
        login_refinery_user

        let!(:blog_category) { FactoryGirl.create(:blog_category, :title => "Video Games") }

        context "when no blog posts" do
          before(:each) { subject.class.destroy_all }

          describe "blog post listing" do
            before(:each) { visit refinery_blog_admin_posts_path }

            it "invites to create new post" do
              page.should have_content("There are no Blog Posts yet. Click \"Create new post\" to add your first blog post.")
            end
          end

          describe "new blog post form" do
            before(:each) do
              visit refinery_blog_admin_posts_path
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
                fill_in "blog_post_body", :with => "And I love it"
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
                fill_in "blog_post_body", :with => "And I also love it"
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
                subject.class.last.tag_list.should eq(@tag_list.split(', '))
              end
            end
          end
        end

        context "when has blog posts" do
          let!(:blog_post) { FactoryGirl.create(:blog_post) }

          describe "blog post listing" do
            before(:each) { visit refinery_blog_admin_posts_path }

            describe "edit blog post" do
              it "should succeed" do
                page.should have_content(blog_post.title)

                click_link("Edit this blog post")
                current_path.should == edit_refinery_blog_admin_post_path(blog_post)

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

                current_path.should == blog_post_path(blog_post)
                page.should have_content(blog_post.title)
              end
            end
          end

          context "when uncategorized post" do
            it "shows up in the list" do
              visit uncategorized_refinery_blog_admin_posts_path
              page.should have_content(blog_post.title)
            end
          end

          context "when categorized post" do
            it "won't show up in the list" do
              blog_post.categories << blog_category
              blog_post.save!

              visit uncategorized_refinery_blog_admin_posts_path
              page.should_not have_content(blog_post.title)
            end
          end
        end

        context "with multiple users" do
          let!(:other_guy) { Factory(:refinery_user, :username => "Other Guy") }

          describe "create blog post with alternate author" do
            before(:each) do
              visit refinery_blog_admin_posts_path
              click_link "Create new post"

              fill_in "Title", :with => "This is some other guy's blog post"
              fill_in "blog_post_body", :with => "I totally didn't write it."

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
      end
    end
  end
end