require 'spec_helper'

module Refinery
  describe 'Blog::Blogs' do
    refinery_login_with :refinery_user

    before (:each) { FactoryGirl.create(:page,
                                        :title => 'Blogs',
                                        :link_url => '/blogs') }

    context 'when there are no blogs' do
      it 'should display no blogs message' do
        visit refinery.blog_blogs_path

        page.should have_content('There are no blogs yet.')
      end
    end 
    
    context 'when there are blogs' do
      let!(:blog) { FactoryGirl.create(:blog) }

      it 'should display blog names' do
        visit refinery.blog_blogs_path

        page.should have_content(blog.name)
      end
    end

    describe "visit blogs" do

      before(:each) do
        Factory.create(:page, :link_url => "/")
        Factory.create(:page, :link_url => "/blogs", :title => "Blogs")
      end

      it "shows blogs link in menu" do
        visit "/"
        within "#menu" do
          page.should have_content("Blogs")
          page.should have_selector("a[href='/blogs']")
        end
      end

    end

  end
end
