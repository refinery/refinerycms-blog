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

            it "should success" do
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

        context "with translations" do
          before(:each) do
            Globalize.locale = :en
            Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])
            blogs_page = Factory.create(:page, :link_url => "/blogs",
                                        :title => "Blogs")
            Globalize.with_locale(:ru) do
              blogs_page.title = 'блог'
              blogs_page.save
            end
            visit refinery.blog_admin_blogs_path
          end

          describe "add a blog with name for default locale" do
            before do
              click_link "Add New Blog"
              fill_in "Name", :with => "FooBar Blog"
              click_button "Save"
              @b = Refinery::Blog::Blog.find_by_name("FooBar Blog")
            end

            it "succeeds" do
              page.should have_content("'FooBar Blog' was successfully added.")
              Refinery::Blog::Blog.count.should eq(1)
            end

            it "shows locale flag for blog" do
              within "#blog_#{@b.id}" do
                page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
              end
            end

            it "shows up for default locale" do
              visit refinery.blog_blog_path(@b)
              page.should have_content("FooBar Blog")
            end

            it "does not show up for secondary locale" do
              visit refinery.blog_blog_path(@b, :locale => :ru)
              page.should have_content("The page you were looking for doesn't exist (404)")
            end

          end

          describe "add a blog name only for secondary locale" do

            let(:ru_blog_name) { 'Новости' }

            before do
              click_link "Add New Blog"
              within "#switch_locale_picker" do
                click_link "Ru"
              end
              fill_in "Name", :with => ru_blog_name
              click_button "Save"
              @b = Refinery::Blog::Blog.find_by_name("Новости")
            end

            it "succeeds" do
              page.should have_content("'#{ru_blog_name}' was successfully added.")
              Refinery::Blog::Blog.count.should eq(1)
            end

            it "shows name in secondary locale" do
              within "#blog_#{@b.id}" do
                page.should have_content(ru_blog_name)
              end
            end

            it "shows locale flag for blog" do
              within "#blog_#{@b.id}" do
                page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
              end
            end

            it "does not show locale flag for primary locale" do
              within "#blog_#{@b.id}" do
                page.should_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
              end
            end

            it "does not show up for default locale" do
              visit refinery.blog_blog_path(@b)
              page.should_not have_content(ru_blog_name)
            end

            it "shows up in blog page for secondary locale" do
              visit refinery.blog_blog_path(@b, :locale => :ru)
              page.should have_content(ru_blog_name)
            end

          end

          context "with a blog in both locales" do

            let!(:blog) do
              _blog = Globalize.with_locale(:en) { FactoryGirl.create(:blog, :name => 'First Blog') }
              Globalize.with_locale(:ru) do
                _blog.name = 'Домашняя страница'
                _blog.save
              end
              _blog
            end

            before(:each) do
              visit refinery.blog_admin_blogs_path
            end

            it "shows both locale flags for blog" do
              within "#blog_#{blog.id}" do
                page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
                page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
              end
            end

            describe "edit the post in english" do
              it "succeeds" do

                within "#blog_#{blog.id}" do
                  click_link("En")
                end
                current_path.should == refinery.edit_blog_admin_blog_path(blog)
                fill_in "Name", :with => "New Blog Title"
                click_button "Save"

                page.should_not have_content(blog.name)
                page.should have_content("'New Blog Title' was successfully updated.")
              end
            end

            describe "edit the post in secondary locale" do
              it "succeeds" do
                within "#blog_#{blog.id}" do
                  click_link("Ru")
                end

                fill_in "Name", :with => "Нов"
                click_button "Save"

                page.should_not have_content(blog.name)
                page.should have_content("'Нов' was successfully updated.")
              end
            end

          end
        end

      end
    end
  end
end
