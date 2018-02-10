require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe CommentsController, type: :controller do
        refinery_login

        describe "#index" do
          let!(:comment) { FactoryBot.create(:blog_comment) }

          it "succeeds" do
            get :index
            expect(response).to be_success
            expect(response).to render_template(:index)
          end

          it "assigns unmoderated comments" do
            get :index
            expect(assigns(:comments).first).to eq(comment)
          end
        end

        describe "#approved" do
          let!(:comment) { FactoryBot.create(:approved_comment) }

          it "succeeds" do
            get :approved
            expect(response).to be_success
            expect(response).to render_template(:index)
          end

          it "assigns approved comments" do
            get :approved
            expect(assigns(:comments).first).to eq(comment)
          end
        end

        describe "#approve" do
          let!(:comment) { FactoryBot.create(:blog_comment) }

          it "redirects on success" do
            post :approve, params: { id: comment.id }
            expect(response).to be_redirect
          end

          it "approves the comment" do
            post :approve, params: { :id => comment.id }
            expect(Refinery::Blog::Comment.approved.count).to eq(1)
          end
        end

        describe "#rejected" do
          let!(:comment) { FactoryBot.create(:rejected_comment) }

          it "succeeds" do
            get :rejected
            expect(response).to be_success
            expect(response).to render_template(:index)
          end

          it "assigns rejected comments" do
            get :rejected
            expect(assigns(:comments).first).to eq(comment)
          end
        end

        describe "#reject" do
          let!(:comment) { FactoryBot.create(:blog_comment) }

          it "redirects on success" do
            post :reject, params: { :id => comment.id }
            expect(response).to be_redirect
          end

          it "rejects the comment" do
            post :reject, params:{ :id => comment.id }
            expect(Refinery::Blog::Comment.rejected.count).to eq(1)
          end
        end
      end
    end
  end
end
