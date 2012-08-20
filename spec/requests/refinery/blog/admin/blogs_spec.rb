# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Blog" do
    describe "Admin" do
      describe "blogs" do
        refinery_login_with :refinery_user

        describe "blogs list" do
          before do
            FactoryGirl.create(:blog, :name => "UniqueTitleOne")
            FactoryGirl.create(:blog, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.blog_admin_blogs_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.blog_admin_blogs_path
            click_link "Add New Blog"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Blog::Blog.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Blog::Blog.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:blog, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.blog_admin_blogs_path

              click_link "Add New Blog"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Blog::Blog.count.should == 1
            end
          end

        end

        describe "edit" do
          let! (:blog) { FactoryGirl.create(:blog, :name => "A name") }

          it 'should show posts list' do
            visit refinery.blog_admin_blogs_path

            within ".actions" do
              click_link "Edit this blog"
            end

            page.should have_content("Blog: A name")
            page.should have_content("There are no Blog Posts yet. Click \"Create new post\" to add your first blog post.")
          end

          describe "change name" do
            before { FactoryGirl.create(:blog, :name => "Another name") }

            it "should succes" do
              visit refinery.blog_admin_blogs_path
              within "#blog_#{blog.id} .actions" do
                click_link "Edit this blog"
              end

              click_link "Edit or delete blog"

              fill_in "Name", :with => "A different name"
              click_button "Save"

              page.should have_content("'A different name' was successfully updated.")
              page.should have_content("Blog: A different name")
              page.should have_no_content("A name")

              visit refinery.blog_admin_blogs_path
              page.should have_content("A different name")
              page.should have_content("Another name")
            end
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:blog, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.blog_admin_blogs_path

            click_link "Remove this blog forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Blog::Blog.count.should == 0
          end
        end

      end
    end
  end
end
