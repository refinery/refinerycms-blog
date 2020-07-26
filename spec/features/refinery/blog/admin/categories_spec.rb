# encoding: utf-8
require 'spec_helper'

module Refinery
  module Blog
    module Admin
      describe Category, type: :feature do
        refinery_login

        let(:title) { "lol" }

        it "can create categories" do
          visit refinery.admin_root_path

          within("nav#menu") { click_link "Blog" }
          within("nav.multilist") { click_link "Create new category" }

          fill_in "Title", :with => title
          click_button "Save"

          category = Refinery::Blog::Category.first
          expect(category.title).to eq(title)
        end

        context "with translations" do
          let(:create_a_blog_page_with_two_locales){
            allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :ru])
            blog_page = Mobility.with_locale(:en) { FactoryBot.create(:page, :link_url => "/blog", :title => "Blog") }
            Mobility.with_locale(:ru) do
              blog_page.title = 'блог'
              blog_page.save
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

          describe "add a category with title for default locale" do
            let(:creating_an_english_category) {
              -> {
                Mobility.locale = :en
                visit refinery.blog_admin_posts_path
                click_link "Create new category"
                fill_in "Title", :with => "Testing Category"
                click_button "Save"
              }
            }
            let(:test_category) {
              Mobility.locale = :en
              FactoryBot.create(:blog_category)
            }

            it "returns a success message. The number of categories has increased" do
              expect(creating_an_english_category).to change(Refinery::Blog::Category, :count).by(1)
              expect(page).to have_content("'Testing Category' was successfully added.")
            end


            it "Manage categories shows locale for category" do
              id = test_category.id
              visit refinery.blog_admin_posts_path
              click_link "Manage"
              selector = "#category_#{id}"
              within selector do
                expect(page).to have_selector('.en.locale_marker')
              end
            end
          
            it "shows up in blog page for default locale" do
              visit refinery.blog_root_path
              within "#categories" do
                expect(page).to have_selector('li')
              end
            end

            it "does not show up in blog page for secondary locale" do
              visit refinery.blog_root_path(:locale => :ru)
              expect(page).not_to have_selector('#categories')
            end

          end

          describe "add a category with title for secondary locale" do

            let(:ru_category_title) { 'категория' }
            let(:creating_a_russian_category) {
              -> {
                Mobility.locale = :ru
                visit refinery.blog_admin_posts_path
                click_link "Create new category"
                within "#switch_locale_picker" do
                  click_link "RU"
                end
                fill_in "Title", :with => ru_category_title
                click_button "Save"
              }
            }
            let(:test_category_ru) {
              Mobility.locale = :ru
              FactoryBot.create(:blog_category)
            }

            # before do
            #   visit refinery.blog_admin_posts_path
            #   click_link "Create new category"
            #   within "#switch_locale_picker" do
            #     click_link "RU"
            #   end
            #   fill_in "Title", :with => ru_category_title
            #   expect { click_button "Save" }.to change(Refinery::Blog::Category, :count).by(1)
            #   @c = Refinery::Blog::Category.by_title(ru_category_title)
          # end

          it "returns a success message. The number of categories has increased" do
            expect(creating_a_russian_category).to change(Refinery::Blog::Category, :count).by(1)
            expect(page).to have_content("'#{ru_category_title}' was successfully added.")
          end


          it "shows locale for category" do
            id = test_category_ru.id
            selector = "#category_#{test_category_ru.id}"
            visit refinery.blog_admin_posts_path
            click_link "Manage"
            within selector do
              expect(page).to have_css(".locale.marker.ru")
            end
          end

          it "does not show locale for primary locale" do
            visit refinery.blog_admin_categories_path
            selector = "#category_#{test_category_ru.id}"
            within selector do
              expect(page).not_to have_css(".locale.marker.en")
            end
          end

          it "does not shows up in blog page for default locale" do
            visit refinery.blog_root_path
            expect(page).not_to have_selector('#categories')
          end

          it "shows up in blog page for secondary locale" do
            visit refinery.blog_root_path(:locale => :ru)
            within "#categories" do
              expect(page).to have_selector('li')
            end
          end
        end
      end
    end
  end
end
