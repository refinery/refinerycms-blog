# encoding: utf-8
require 'spec_helper'

module Refinery
  module Blog
    module Admin
      describe Category, type: :feature do
        refinery_login

      def create_a_blog_page(locales, titles, url)
        allow(Refinery::I18n).to receive(:frontend_locales).and_return(locales)
        blog_page = Mobility.with_locale(locales.first) { FactoryBot.create(:page, link_url: url, title: "Blog") }
        titles.each do |locale, locale_title|
          Mobility.with_locale(locale) do
            blog_page.title = locale_title
          end
          blog_page.save
        end
      end

      def create_a_category(title, locale = :en)
        Mobility.locale = locale
        visit refinery.blog_admin_posts_path
        click_link "Create new category"
        within "#switch_locale_picker" do
          click_link locale.upcase
        end
        fill_in "Title", with: title
        click_button "Save"
      end

      let(:creating_a_category) {
        -> {
          visit refinery.blog_admin_posts_path
          click_link "Create new category"
          within "#switch_locale_picker" do
            click_link locale.upcase
          end
          fill_in "Title", with: title
          click_button "Save"
<<<<<<< HEAD
        }
      }

      describe Category, type: :feature do
        refinery_login

        let(:title) { "lol" }
        it 'creates a category', js: true do
          expect(creating_a_category).to change(Refinery::Blog::Category, :count).by(1)
        end

        context "with translations" do
          let(:page_titles) { [
            { locale: :en, title: "Diary" },
            { locale: :ru, title: 'блог' }
          ] }
          before do
            create_a_blog_page([:en, :ru], page_titles, '/blog')
          end
          }
          # before do
          #   allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])
          #   blog_page = Mobility.with_locale(:en) { FactoryBot.create(:page, :link_url => "/blog", :title => "Blog") }
          #   Mobility.with_locale(:ru) do
          #     blog_page.title = 'блог'
          #     blog_page.save
          #   end
        end

        describe "adding a category with title for default locale" do
          before do
            Mobility.locale = :en
            create_a_category(:en, 'jokes')
          end
        end

          it "Categories are available in blog page for default locale" do
            visit refinery.blog_root_path
            expect(page).to have_selector('#categories')
          end

          it "Categories are not available in blog page for secondary locale" do
            visit refinery.blog_root_path(locale: :ru)
            expect(page).not_to have_selector('#categories')
          end
=======
>>>>>>> 5a1a4d0 (WIP. Testing needs more work)
        end

        def create_page(title, url, locales = [:en])
          allow(Refinery::I18n).to receive(:frontend_locales).and_return(locales)
          Mobility.with_locale(locales.first) { FactoryBot.create(:page, link_url: "/blog", title: "Blog") }
        end

        def add_locale_to_page(page, title, locale)
          Mobility.with_locale(locale) do
            page.title = title
            page.save
          end
        end

        describe "Creating Categories" do
          describe 'creating a category' do
            subject(:perform) do
              create_category('lol')
            end
            include_examples 'creates a new object', Refinery::Blog::Category
          end

          context "with translations" do
            before do
              blog_page = create_page('Blog', '/blog', [:en, :ru])
              add_locale_to_page(blog_page, 'блог', :ru)
            end

            describe "add a category with title for default locale" do
              subject(:perform) do
                create_category('Testing Category')
              end
              include_examples 'creates a new object', Refinery::Blog::Category

              it "the category is listed with the :en locale" do
                visit refinery.blog_admin_categories_path
                within('#category_1') do
                  expect(page).to have_selector('a.local.en')
                end
              end

              it "shows up in blog page for default locale" do
                visit refinery.blog_root_path

                within "#categories" do
                  expect(page).to have_selector('li')
                end
              end

              it "does not show up in blog page for secondary locale" do
                visit refinery.blog_root_path(locale: :ru)
                expect(page).not_to have_selector('#categories')
              end

            end

            describe "add a category with title for secondary locale" do

              let(:ru_category_title) { 'категория' }

              before do
                visit refinery.blog_admin_posts_path
                click_link "Create new category"
                within "#switch_locale_picker" do
                  click_link "RU"
                end
                fill_in "Title", with: ru_category_title
                expect { click_button "Save" }.to change(Refinery::Blog::Category, :count).by(1)
                @c = Refinery::Blog::Category.by_title(ru_category_title)
              end

              it "suceeds" do
                expect(page).to have_content("'#{@c.title_translations['ru']}' was successfully added.")
                expect(Refinery::Blog::Category.count).to eq(1)
              end

              it "shows locale for category" do
                click_link "Manage"
                within "#category_#{@c.id}" do
                  expect(page).to have_css(".locale .ru")
                end
              end

              it "does not show locale for primary locale" do
                click_link "Manage"
                within "#category_#{@c.id}" do
                  expect(page).not_to have_css(".locale .en")
                end
              end

              it "does not shows up in blog page for default locale" do
                visit refinery.blog_root_path
                expect(page).not_to have_selector('#categories')
              end

              it "shows up in blog page for secondary locale" do
                visit refinery.blog_root_path(locale: :ru)
                within "#categories" do
                  expect(page).to have_selector('li')
                end
              end
            end
          end
        end
      end
    end
  end
end
