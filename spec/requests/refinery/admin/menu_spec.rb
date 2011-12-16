require 'spec_helper'

describe "Blog menu entry" do
  login_refinery_user

  it "is highlighted when managing the blog" do
    visit refinery_admin_root_path

    within("#menu") { click_link "Blog" }

    page.should have_css("a.active", :text => "Blog")
  end
end
