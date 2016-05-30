require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe Comment, type: :feature do
        refinery_login

        describe "#index" do
          context "when has no new unapproved comments" do
            before do
              subject.class.delete_all
              visit refinery.blog_admin_comments_path
            end

            it "should list no comments" do
              visit refinery.blog_admin_comments_path

              expect(page).to have_content('There are no new comments')
            end
          end
          context "when has new unapproved comments" do
            let!(:blog_comment) { FactoryGirl.create(:blog_comment) }
            before { visit refinery.blog_admin_comments_path }

            it "should list comments" do
              expect(page).to have_content(blog_comment.body)
              expect(page).to have_content(blog_comment.name)
            end

            it "should allow me to approve a comment" do
              click_link "Approve this comment"

              expect(page).to have_content("has been approved")
            end

            it "should allow me to reject a comment" do
              click_link "Reject this comment"

              expect(page).to have_content("has been rejected")
            end
          end
        end

        describe "#approved" do
          context "when has no approved comments" do
            before do
              subject.class.delete_all
              visit refinery.approved_blog_admin_comments_path
            end

            it "should list no comments" do
              expect(page).to have_content('There are no approved comments')
            end
          end
          context "when has approved comments" do
            let!(:blog_comment) do
              FactoryGirl.create(:blog_comment, :state => 'approved')
            end
            before { visit refinery.approved_blog_admin_comments_path }

            it "should list comments" do
              expect(page).to have_content(blog_comment.body)
              expect(page).to have_content(blog_comment.name)
            end

            it "should allow me to reject a comment" do
              click_link "Reject this comment"

              expect(page).to have_content("has been rejected")
            end
          end
        end

        describe "#rejected" do
          context "when has no rejected comments" do
            before do
              subject.class.delete_all
              visit refinery.rejected_blog_admin_comments_path
            end

            it "should list no comments" do
              expect(page).to have_content('There are no rejected comments')
            end
          end
          context "when has rejected comments" do
            let!(:blog_comment) do
              FactoryGirl.create(:blog_comment, :state => 'rejected')
            end
            before { visit refinery.rejected_blog_admin_comments_path }

            it "should list comments" do
              expect(page).to have_content(blog_comment.body)
              expect(page).to have_content(blog_comment.name)
            end

            it "should allow me to approve a comment" do
              click_link "Approve this comment"

              expect(page).to have_content("has been approved")
            end
          end
        end

        describe "#show" do
          let!(:blog_comment) { FactoryGirl.create(:blog_comment) }
          before { visit refinery.blog_admin_comment_path(blog_comment) }
          it "should display the comment" do
            expect(page).to have_content(blog_comment.body)
            expect(page).to have_content(blog_comment.name)
          end
          it "should allow me to approve the comment" do
            click_link "Approve this comment"

            expect(page).to have_content("has been approved")
          end
        end
      end
    end
  end
end
