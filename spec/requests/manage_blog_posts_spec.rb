require "spec_helper"

describe "manage blog posts" do
  # TODO: share this with other request specs
  before(:each) do
    Factory(:refinery_user, :username => "refinerycms",
                            :password => "123456",
                            :password_confirmation => "123456")
    visit new_refinery_user_session_url
    fill_in "Login", :with => "refinerycms"
    fill_in "Password", :with => "123456"
    click_button "Sign in"
  end

  let!(:blog_post) { Factory(:blog_post, :title => "Refinery CMS blog post") }

  context "when no blog posts" do
    before(:each) { Refinery::BlogPost.destroy_all }

    it "invites to create new post" do
      visit refinery_admin_blog_posts_path
      page.should have_content("There are no Blog Posts yet. Click \"Create new post\" to add your first blog post.")
    end
  end
  
  context "when creating blog post" do
    it "should succeed" do
      visit refinery_admin_blog_posts_path
      click_link "Create new post"

      fill_in "Title", :with => "Another Refinery CMS blog post"
      fill_in "blog_post_body", :with => "Bla bla"
      click_button "Save"

      page.should have_content("'Another Refinery CMS blog post' was successfully added.")
      # this probably is matching the same 'Another Refinery CMS blog post' in flash message!?
      page.should have_content("Another Refinery CMS blog post")
    end
  end
  
  context "when editing blog post" do
    it "should succeed" do
      visit refinery_admin_blog_posts_path
      page.should have_content("Refinery CMS blog post")

      click_link("Edit this blog post")
      current_path.should == edit_refinery_admin_blog_post_path(blog_post)

      fill_in "Title", :with => "hax0r"
      click_button "Save"

      page.should_not have_content("Refinery CMS blog post")
      page.should have_content("'hax0r' was successfully updated.")
      # this probably is matching the same 'hax0r' in flash message!?
      page.should have_content("hax0r")
    end
  end
  
  context "when deleting blog post" do
    it "should succeed" do
      pending "need to figure out how to accept js popup"

      visit refinery_admin_blog_posts_path
      page.should have_content("Refinery CMS blog post")

      click_link "Remove this blog post forever"

      page.should_not have_content("Refinery CMS blog post")
    end
  end
end
