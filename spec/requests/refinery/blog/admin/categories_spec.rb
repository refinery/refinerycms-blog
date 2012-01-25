require 'spec_helper'

describe "Categories admin" do
  login_refinery_user

  let(:title) { "lol" }

  it "can create categories" do
    visit refinery_admin_root_path

    within("nav#menu") { click_link "Blog" }
    within("nav.multilist") { click_link "Create new category" }

    fill_in "Title", :with => title
    click_button "Save"

    category = Refinery::Blog::Category.first
    category.title.should eq(title)
  end
end
