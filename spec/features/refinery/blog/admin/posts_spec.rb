# encoding: utf-8
require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe Post, type: :feature do
        refinery_login_with_devise :authentication_devise_refinery_superuser

        let!(:blog_category) do
          Globalize.with_locale(:en) { FactoryGirl.create(:blog_category) }
        end

        context "when no blog posts" do
          before { subject.class.destroy_all }

          describe "blog post listing" do
            before { visit refinery.blog_admin_posts_path }

            it "invites to create new post" do
              expect(page).to have_content("There are no Blog Posts yet. Click \"Create new post\" to add your first blog post.")
            end
          end

          describe "new blog post form" do
            before do
              visit refinery.blog_admin_posts_path
              click_link "Create new post"
            end

            it "should have Tags" do
              expect(page).to have_content("Tags")
            end

            it "should have category title" do
              expect(page).to have_content(blog_category.title)
            end

            describe "create blog post" do
              before do
                expect(subject.class.count).to eq(0)
                fill_in "post_title", with: "This is my blog post"
                fill_in "post_body", with: "<p>And I love it</p>"
                fill_in "post_user_id", with: "John Doe"

                expect(page).to have_css '.blog_categories'
                expect(page).to have_css "#post_category_ids_#{blog_category.id}"
                expect { check(blog_category.title) }.to change {
                  !!page.find("#post_category_ids_#{blog_category.id}").checked?
                }.from(false).to(true)

                click_button "Save"

                expect(page).to have_content("was successfully added.")
              end

              it "should be the only blog post" do
                expect(subject.class.count).to eq(1)
              end

              it "should save categories" do
                expect(subject.class.last.categories.count).to eq(1)
                expect(subject.class.last.categories.first.title).to eq(blog_category.title)
              end
            end

            describe "create blog post with tags" do
              let(:tag_list) { "chicago, bikes, beers, babes" }
              before do
                fill_in "Title", with: "This is a tagged blog post"
                fill_in "post_body", with: "<p>And I also love it</p>"
                fill_in "post_user_id", with: "John Doe"
                fill_in "Tags", with: tag_list
                click_button "Save"
              end

              it "should succeed" do
                expect(page).to have_content("was successfully added.")
              end

              it "should be the only blog post" do
                expect(subject.class.count).to eq(1)
              end

              it "should have the specified tags" do
                expect(subject.class.last.tag_list.sort).to eq(tag_list.split(', ').sort)
              end
            end
          end
        end

        context "when has blog posts" do
          let!(:blog_post) do
            Globalize.with_locale(:en) { FactoryGirl.create(:blog_post) }
          end

          describe "blog post listing" do
            before { visit refinery.blog_admin_posts_path }

            describe "edit blog post" do
              it "should succeed" do
                expect(page).to have_content(blog_post.title)

                click_link("Edit this blog post")
                expect(current_path).to eq(refinery.edit_blog_admin_post_path(blog_post))

                fill_in "post_title", :with => "hax0r"
                click_button "Save"

                expect(page).not_to have_content(blog_post.title)
                expect(page).to have_content("'hax0r' was successfully updated.")
              end
            end

            describe "deleting blog post" do
              it "should succeed" do
                expect(page).to have_content(blog_post.title)

                click_link "Remove this blog post forever"

                expect(page).to have_content("'#{blog_post.title}' was successfully removed.")
              end
            end

            describe "view live" do
              it "redirects to blog post in the frontend" do
                click_link "View this blog post live"

                expect(current_path).to eq(refinery.blog_post_path(blog_post))
                expect(page).to have_content(blog_post.title)
              end
            end
          end

          context "when uncategorized post" do
            it "shows up in the list" do
              visit refinery.uncategorized_blog_admin_posts_path
              expect(page).to have_content(blog_post.title)
            end
          end

          context "when categorized post" do
            it "won't show up in the list" do
              blog_post.categories << blog_category
              blog_post.save!

              visit refinery.uncategorized_blog_admin_posts_path
              expect(page).not_to have_content(blog_post.title)
            end
          end
        end

        context "with multiple users" do
          before do
            allow(Refinery::Blog).to receive(:user_class).and_return(Refinery::Authentication::Devise::User)
            class Refinery::Blog::Post
              belongs_to :author, proc { readonly(true) }, :class_name => Refinery::Blog.user_class.to_s, :foreign_key => :user_id
            end
          end

          let!(:other_guy) { FactoryGirl.create(:authentication_devise_refinery_user, :username => "Other Guy") }

          describe "create blog post with alternate author" do
            before do
              visit refinery.blog_admin_posts_path
              click_link "Create new post"

              fill_in "post_title", :with => "This is some other guy's blog post"
              fill_in "post_body", with: "<p>I totally did not write it.</p>"

              expect(page).to have_content("Author")
              select other_guy.username, from: "Author"

              click_button "Save"
              expect(page).to have_content("was successfully added.")
            end

            it "belongs to another user" do
              expect(subject.class.last.author).to eq(other_guy)
            end
          end
        end

        context "with translations" do
          before do
            Globalize.locale = :en
            allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])
            blog_page = FactoryGirl.create(:page, :link_url => "/blog", :title => "Blog")
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
              fill_in "post_user_id", with: "John Doe"
              click_button "Save"
              @p = Refinery::Blog::Post.by_title("Post")
            end

            it "succeeds" do
              expect(page).to have_content("'Post' was successfully added.")
              expect(Refinery::Blog::Post.count).to eq(1)
            end

            it "shows locale for post" do

              within "#post_#{@p.id}" do
                expect(page).to have_css(".locale_icon.en")
              end
            end

            it "shows up in blog page for default locale" do
              visit refinery.blog_admin_root_path
              expect(page).to have_selector("#post_#{@p.id}")
            end

            it "does show locale for default locale" do
              within "#post_#{@p.id}" do
                expect(page).to have_css(".locale_icon.en")
              end
            end

            it "does not show locale for secondary locale" do
              within "#post_#{@p.id}" do
                expect(page).not_to have_css(".locale_icon.ru")
              end
            end

          end

          describe "add a blog post with title only for secondary locale" do

            let(:ru_page_title) { 'Новости' }

            before do
              click_link "Create new post"
              within "#switch_locale_picker" do
                click_link "RU"
              end
              fill_in "Title", with: ru_page_title
              fill_in "post_body", with: "One post in my blog"
              fill_in "post_user_id", with: "John Doe"
              click_button "Save"
              @p = Refinery::Blog::Post.by_title(ru_page_title)
            end

            it "succeeds" do
              expect(page).to have_content("was successfully added.")
              expect(Refinery::Blog::Post.count).to eq(1)
            end

            it "shows title in secondary locale" do
              within "#post_#{@p.id}" do
                expect(page).to have_content(ru_page_title)
              end
            end

            it "shows locale for post" do
              within "#post_#{@p.id}" do
                expect(page).to have_css(".locale_icon.ru")
              end
            end

            it "does not show locale for primary locale" do
              within "#post_#{@p.id}" do
                expect(page).not_to have_css(".locale_icon.en")
              end
            end

            it "does show locale for secondary locale" do
              within "#post_#{@p.id}" do
                expect(page).to have_css(".locale_icon.ru")
              end
            end

            it "shows up in blog page for secondary locale" do
              visit refinery.blog_admin_root_path(:locale => :ru)
              expect(page).to have_selector("#post_#{@p.id}")
            end

          end

          context "with a blog post in both locales" do

            let!(:blog_post) do
              _blog_post = Globalize.with_locale(:en) { FactoryGirl.create(:blog_post, :title => 'First Post') }
              Globalize.with_locale(:ru) do
                _blog_post.title = 'Домашняя страница'
                _blog_post.save
              end
              _blog_post
            end

            before do
              visit refinery.blog_admin_posts_path
            end

            it "shows both locales for post" do
              within "#post_#{blog_post.id}" do
                expect(page).to have_css(".locale_icon.en")
                expect(page).to have_css(".locale_icon.ru")
              end
            end

            describe "edit the post in english" do
              it "succeeds" do

                within "#post_#{blog_post.id}" do
                  click_link("EN")
                end
                expect(current_path).to eq(refinery.edit_blog_admin_post_path(blog_post))
                fill_in "Title", :with => "New Post Title"
                click_button "Save"

                expect(page).not_to have_content(blog_post.title)
                expect(page).to have_content("'New Post Title' was successfully updated.")
              end
            end

            describe "edit the post in secondary locale" do
              it "succeeds" do
                within "#post_#{blog_post.id}" do
                  click_link("RU")
                end

                fill_in "Title", :with => "Нов"
                click_button "Save"

                expect(page).not_to have_content(blog_post.title)
                expect(page).to have_content("'Нов' was successfully updated.")
              end
            end

            describe "delete the post translation in secondary locale" do
              it "succeeds" do
                within "#post_#{blog_post.id}" do
                  click_link("RU")
                end

                click_link "Remove this translation"

                expect(page).not_to have_content(blog_post.title)
                expect(page).to have_content("The translation was successfully removed.")
              end
            end
          end
        end

      end
    end
  end
end
