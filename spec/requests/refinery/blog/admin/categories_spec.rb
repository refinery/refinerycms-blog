# encoding: utf-8
require 'spec_helper'

describe "Categories admin" do
  refinery_login_with :refinery_user

  let(:title) { "lol" }

  it "can create categories" do
    visit refinery.admin_root_path

    within("nav#menu") { click_link "Blog" }
    within("nav.multilist") { click_link "Create new category" }

    fill_in "Title", :with => title
    click_button "Save"

    category = Refinery::Blog::Category.first
    category.title.should eq(title)
  end

  context "with translations" do
    before(:each) do
      Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])
      blog_page = Globalize.with_locale(:en) { Factory.create(:page, :link_url => "/blog", :title => "Blog") }
      Globalize.with_locale(:ru) do
        blog_page.title = 'блог'
        blog_page.save
      end
    end

    describe "add a category with title for default locale" do
      before do
        Globalize.locale = :en
        visit refinery.blog_admin_posts_path
        click_link "Create new category"
        fill_in "Title", :with => "Testing Category"
        click_button "Save"
        @c = Refinery::Blog::Category.find_by_title("Testing Category")
      end

      it "suceeds" do
        page.should have_content("'#{@c.title}' was successfully added.")
        Refinery::Blog::Category.count.should eq(1)
      end

      it "shows locale flag for category" do
        click_link "Manage"
        within "#category_#{@c.id}" do
          page.should have_css("img[src='/assets/refinery/icons/flags/en.png']")
        end
      end

      it "shows up in blog page for default locale" do
        visit refinery.blog_root_path
        within "#categories" do
          page.should have_selector('li')
        end
      end

      it "does not show up in blog page for secondary locale" do
        visit refinery.blog_root_path(:locale => :ru)
        page.should_not have_selector('#categories')
      end

    end

    describe "add a category with title for secondary locale" do

      let(:ru_category_title) { 'категория' }

      before do
        visit refinery.blog_admin_posts_path
        click_link "Create new category"
        within "#switch_locale_picker" do
          click_link "Ru"
        end
        fill_in "Title", :with => ru_category_title
        click_button "Save"
        @c = Refinery::Blog::Category.find_by_title(ru_category_title)
      end

      it "suceeds" do
        page.should have_content("'#{@c.title}' was successfully added.")
        Refinery::Blog::Category.count.should eq(1)
      end

      it "shows locale flag for category" do
        click_link "Manage"
        within "#category_#{@c.id}" do
          page.should have_css("img[src='/assets/refinery/icons/flags/ru.png']")
        end
      end

      it "does not show locale flag for primary locale" do
        click_link "Manage"
        within "#category_#{@c.id}" do
          page.should_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
        end
      end

      it "does not shows up in blog page for default locale" do
        visit refinery.blog_root_path
        page.should_not have_selector('#categories')
      end

      it "shows up in blog page for secondary locale" do
        visit refinery.blog_root_path(:locale => :ru)
        within "#categories" do
          page.should have_selector('li')
        end
      end


    end


  end
end
