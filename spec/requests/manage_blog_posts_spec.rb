require "spec_helper"

describe "manage blog posts" do
  # TODO: share this with other request specs
  before(:each) do
    user = Factory.create(:refinery_user)
    visit new_refinery_user_session_url
    fill_in "Login", :with => user.username
    fill_in "Password", :with => user.password
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
    end
  end
  
  context "when editing blog post" do
    it "should succeed" do
      visit refinery_admin_blog_posts_path
      page.should have_content(blog_post.title)

      click_link("Edit this blog post")
      current_path.should == edit_refinery_admin_blog_post_path(blog_post)

      fill_in "Title", :with => "hax0r"
      click_button "Save"

      page.should_not have_content(blog_post.title)
      page.should have_content("'hax0r' was successfully updated.")
    end
  end

  context "when deleting blog post" do
    it "should succeed" do

      visit refinery_admin_blog_posts_path
      page.should have_content(blog_post.title)

      click_link "Remove this blog post forever"

      page.should have_content("'#{blog_post.title}' was successfully removed.")
    end
  end

  context "uncategorized post" do
    it "shows up in the list" do
      visit uncategorized_refinery_admin_blog_posts_path
      page.should have_content(blog_post.title)
    end
  end

  context "categorized post" do
    it "won't show up in the list" do
      blog_post.categories << Factory(:blog_category)
      blog_post.save!

      visit uncategorized_refinery_admin_blog_posts_path
      page.should_not have_content(blog_post.title)
    end
  end

  describe "view live" do
    it "redirects to blog post in the frontend" do
      visit refinery_admin_blog_posts_path
      click_link "View this blog post live"

      current_path.should == blog_post_path(blog_post)
      page.should have_content(blog_post.title)
    end
  end
end
