require 'spec_helper'

describe "Blog menu entry", type: :feature do
  refinery_login

  it "is highlighted when managing the blog" do
    visit refinery.admin_root_path

    within("#menu") { click_link "Blog" }

    expect(page).to have_css("a.active", :text => "Blog")
  end
end
