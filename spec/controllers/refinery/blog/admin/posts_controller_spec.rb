require "spec_helper"

module Refinery
  module Blog
    module Admin
      describe PostsController, type: :controller do
        refinery_login

        describe "#delete_translation" do
          let!(:blog_post) { FactoryGirl.create(:blog_post) }

          before do
            blog_post.translations.create(:locale => :fr, :title => 'Un titre francais', :body => "La baguette, c'est bon. Mangez-en.")
            blog_post.translations.create(:locale => :es, :title => 'Un titulo espanol', :body => "Mi casa e su casa.")
          end

          it "destroys the translation" do
            post :delete_translation, :id => blog_post.id, :locale_to_delete => :fr
            expect(blog_post.translations.exists?(:locale => :fr)).to be_falsey
          end

          it "does not destroy other translations" do
            post :delete_translation, :id => blog_post.id, :locale_to_delete => :fr
            expect(blog_post.translations.exists?(:locale => :es)).to be_truthy
          end

          it "redirects on success" do
            post :delete_translation, :id => blog_post.id, :locale_to_delete => :fr
            expect(response).to be_redirect
          end
        end
      end
    end
  end
end
