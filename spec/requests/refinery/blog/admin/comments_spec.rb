require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe Comment do
        refinery_login_with :refinery_user

        let (:blog) { FactoryGirl.create(:blog) }
        let (:blog_post) { FactoryGirl.create(:blog_post, :blog => blog) }
        
        describe "#index" do
          context "when has no new unapproved comments" do
            before(:each) do
              subject.class.delete_all
              visit refinery.blog_admin_blog_comments_path(blog)
            end

            it "should list no comments" do
              visit refinery.blog_admin_blog_comments_path(blog)

              page.should have_content('There are no new comments')
            end
          end
          context "when has new unapproved comments" do
            let!(:blog_comment) { FactoryGirl.create(:blog_comment,
                                                     :post => blog_post) }
            before(:each) { visit refinery.blog_admin_blog_comments_path(blog) }

            it "should list comments" do
              page.should have_content(blog_comment.body)
              page.should have_content(blog_comment.name)
            end

            it "should allow me to approve a comment" do
              click_link "Approve this comment"

              page.should have_content("has been approved")
            end

            it "should allow me to reject a comment" do
              click_link "Reject this comment"

              page.should have_content("has been rejected")
            end
          end
        end

        describe "#approved" do
          context "when has no approved comments" do
            before(:each) do
              subject.class.delete_all
              visit refinery.approved_blog_admin_blog_comments_path(blog)
            end

            it "should list no comments" do
              page.should have_content('There are no approved comments')
            end
          end
          context "when has approved comments" do
            let!(:blog_comment) do
              FactoryGirl.create(:blog_comment,
                                 :state => 'approved',
                                 :post => blog_post)
            end
            before(:each) { visit refinery.approved_blog_admin_blog_comments_path(blog) }

            it "should list comments" do
              page.should have_content(blog_comment.body)
              page.should have_content(blog_comment.name)
            end

            it "should allow me to reject a comment" do
              click_link "Reject this comment"

              page.should have_content("has been rejected")
            end
          end
        end

        describe "#rejected" do
          context "when has no rejected comments" do
            before(:each) do
              subject.class.delete_all
              visit refinery.rejected_blog_admin_blog_comments_path(blog)
            end

            it "should list no comments" do
              page.should have_content('There are no rejected comments')
            end
          end
          context "when has rejected comments" do
            let!(:blog_comment) do
              FactoryGirl.create(:blog_comment,
                                 :state => 'rejected',
                                 :post => blog_post)
            end
            before(:each) { visit refinery.rejected_blog_admin_blog_comments_path(blog) }

            it "should list comments" do
              page.should have_content(blog_comment.body)
              page.should have_content(blog_comment.name)
            end

            it "should allow me to approve a comment" do
              click_link "Approve this comment"

              page.should have_content("has been approved")
            end
          end
        end

        describe "#show" do
          let!(:blog_comment) { FactoryGirl.create(:blog_comment) }
          before(:each) { visit refinery.blog_admin_blog_comment_path(blog, blog_comment) }
          it "should display the comment" do
            page.should have_content(blog_comment.body)
            page.should have_content(blog_comment.name)
          end
          it "should allow me to approve the comment" do
            click_link "Approve this comment"

            page.should have_content("has been approved")
          end
        end

        context 'multiblog' do

          let!(:blog_2) { FactoryGirl.create(:blog) }
          let!(:comment) {FactoryGirl.create(:blog_comment,
                                             :post => blog_post) }

          it 'should show comment for the apropiate blog' do
            visit refinery.blog_admin_blog_comments_path(blog)
            page.should have_content(comment.body)
          end

          it 'should not show comment in other blogs' do
            visit refinery.blog_admin_blog_comments_path(blog_2)
            page.should_not have_content(comment.body)
          end

        end
        
      end
    end
  end
end
