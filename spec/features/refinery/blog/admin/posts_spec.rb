# encoding: utf-8
require "spec_helper"

shared_context "with_user_class" do
  # This context changes the user class and updates the author association on Post.
  before :each do
    @old_user_class = Refinery::Blog.user_class
    allow(Refinery::Blog).to receive(:user_class).and_return(Refinery::Blog::TestUser)
    Refinery::Blog::Post.reflections['author'].instance_variable_set(:@class_name, Refinery::Blog.user_class.to_s)
  end

  after :each do
    Refinery::Blog::Post.reflections['author'].instance_variable_set(:@class_name, @old_user_class.to_s)
  end
end

module Refinery
  module Blog
    module Admin
      describe Post, type: :feature do
        refinery_login

        let!(:blog_category) do
          Mobility.with_locale(:en) { FactoryBot.create(:blog_category) }
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
            Mobility.with_locale(:en) { FactoryBot.create(:blog_post) }
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
          include_context "with_user_class"

          let!(:other_guy) { FactoryBot.create(:blog_test_user, :username => "Other Guy") }

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
            Mobility.locale = :en
            allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])
            blog_page = FactoryBot.create(:page, :link_url => "/blog", :title => "Blog")
            Mobility.with_locale(:ru) do
              blog_page.title = 'блог'
              blog_page.save
            end
            visit refinery.blog_admin_posts_path
          end

          describe "add a blog post with title for default locale" do
            let(:creating_a_new_post) {
              -> {
                visit refinery.blog_admin_posts_path
                click_link "Create new post"
                fill_in "Title", with: "Post"
                fill_in "post_body", with: "One post in my blog"
                fill_in "post_user_id", with: "John Doe"
                click_button "Save" }
            }

            let(:first_post) { Refinery::Blog::Post.by_title('Post') }

            # before do
            #   click_link "Create new post"
            #   fill_in "Title", with: "Post"
            #   fill_in "post_body", with: "One post in my blog"
            #   fill_in "post_user_id", with: "John Doe"
            #   click_button "Save"
            #   @p = Refinery::Blog::Post.by_title("Post")
            # end

            it "Increases the number of posts by 1 and returns a success message" do
              expect(creating_a_new_post).to change(Refinery::Blog::Post, :count).by(1)
              expect(page).to have_content("'Post' was successfully added.")
            end

            it "shows locale for post" do
              visit refinery.blog_admin_root_path

              puts  first_post.nil? ? "first post is nil" : "first post id is #{first_post.id}"
              post_id = first_post.id
              selector = "#post_#{post_id}"
              within selector do
                expect(page).to have_css(".locale .en")
              end
            end

            it "shows up in blog page for default locale" do
              visit refinery.blog_admin_root_path
              expect(page).to have_selector("#post_#{first_post.id}")
            end

            it "shows the locale for the default locale" do
              within "#post_#{first_post.id}" do
                expect(page).to have_css(".locale .en")
              end
            end

            it "does not show locale for secondary locale" do
              within "#post_#{first_post.id}" do
                expect(page).not_to have_css(".locale .ru")
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
                expect(page).to have_css(".locale .ru")
              end
            end

            it "does not show locale for primary locale" do
              within "#post_#{@p.id}" do
                expect(page).not_to have_css(".locale .en")
              end
            end

            it "does show locale for secondary locale" do
              within "#post_#{@p.id}" do
                expect(page).to have_css(".locale .ru")
              end
            end

            it "shows up in blog page for secondary locale" do
              visit refinery.blog_admin_root_path(:locale => :ru)
              expect(page).to have_selector("#post_#{@p.id}")
            end

          end

          context "with a blog post in both locales" do

            let!(:blog_post) do
              _blog_post = Mobility.with_locale(:en) { FactoryBot.create(:blog_post, :title => 'First Post') }
              Mobility.with_locale(:ru) do
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
                expect(page).to have_css(".locale .en")
                expect(page).to have_css(".locale .ru")
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

                expect(page).to have_content("'Нов' was successfully updated.")
              end
            end

            describe "delete the post translation in secondary locale" do
              it "succeeds" do
                within "#post_#{blog_post.id}" do
                  click_link("RU")
                end

                click_link "Remove this translation"

                expect(page).not_to have_content('RU')
                expect(page).to have_content("The translation was successfully removed.")
              end
            end
          end
        end

      end
    end
  end
end
