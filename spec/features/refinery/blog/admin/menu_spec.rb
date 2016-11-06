require 'spec_helper'

module Refinery
  module Blog
    module Admin
      describe Menu, type: :feature do
        refinery_login_with_devise :authentication_devise_refinery_superuser if defined?(Refinery::Authentication::Devise::User)

        it "is highlighted when managing the blog" do
          visit refinery.admin_root_path

          within("nav#menu") { click_link "Blog" }

          expect(page).to have_css("a.active", :text => "Blog")
        end
      end
    end
  end
end
