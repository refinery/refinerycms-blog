require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe CommentsController do
        refinery_login_with :refinery_user

        describe "#index" do
          let!(:comment) { FactoryGirl.create(:blog_comment) }
          
          it "succeeds" do
            get :index
            response.should be_success
            response.should render_template(:index)
          end

          it "assigns unmoderated comments" do
            get :index
            assigns(:comments).first.should eq(comment)
          end
        end

        describe "#approved" do
          let!(:comment) { FactoryGirl.create(:approved_comment) }

          it "succeeds" do
            get :approved
            response.should be_success
            response.should render_template(:index)
          end

          it "assigns approved comments" do
            get :approved
            assigns(:comments).first.should eq(comment)
          end
        end

        describe "#approve" do
          let!(:comment) { FactoryGirl.create(:blog_comment) }

          it "redirects on success" do
            post :approve, :id => comment.id
            response.should be_redirect
          end
          
          it "approves the comment" do
            post :approve, :id => comment.id
            Refinery::Blog::Comment.approved.count.should eq(1)
          end
        end
        
        describe "#rejected" do
          let!(:comment) { FactoryGirl.create(:rejected_comment) }

          it "succeeds" do
            get :rejected
            response.should be_success
            response.should render_template(:index)
          end

          it "assigns rejected comments" do
            get :rejected
            assigns(:comments).first.should eq(comment)
          end
        end

        describe "#reject" do
          let!(:comment) { FactoryGirl.create(:blog_comment) }

          it "redirects on success" do
            post :reject, :id => comment.id
            response.should be_redirect
          end
          
          it "rejects the comment" do
            post :reject, :id => comment.id
            Refinery::Blog::Comment.rejected.count.should eq(1)
          end
        end
      end
    end
  end
end
