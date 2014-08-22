require 'spec_helper'

module Refinery
  module Blog
    describe PostsHelper do
      describe "#blog_archive_widget", type: :helper do
        let(:html) { helper.blog_archive_widget(dates) }
        let(:links) { Capybara.string(html).find("#blog_archive_widget ul") }

        context "with no archive dates" do
          let(:dates) { [] }

          it "does not display anything" do
            html.should be_blank
          end
        end

        context "with archive dates" do
          let(:recent_post) { 2.months.ago }
          let(:old_post) { 4.years.ago }

          let(:dates) do
            [old_post, recent_post].map do |date|
              [date, date.beginning_of_month, date.end_of_month]
            end.flatten
          end

          it "has a link for the month of dates not older than one year" do
            month = Date::MONTHNAMES[recent_post.month]
            year = recent_post.year

            links.should have_link("#{month} #{year} (3)")
          end

          it "has a link for the year of dates older than one year" do
            year = old_post.year

            links.should have_link("#{year} (3)")
          end

          it "sorts recent links before old links" do
            links.find("li:first").should have_content(recent_post.year.to_s)
            links.find("li:last").should have_content(old_post.year.to_s)
          end
        end

        context "with multiple recent dates" do
          let(:dates) { [3.months.ago, 2.months.ago] }

          it "sorts by the more recent date" do
            first, second = dates.map {|p| Date::MONTHNAMES[p.month] }

            links.find("li:first").should have_content(second)
            links.find("li:last").should have_content(first)
          end
        end

        context "with multiple old dates" do
          let(:dates) { [5.years.ago, 4.years.ago] }

          it "sorts by the more recent date" do
            first, second = dates.map {|p| p.year.to_s }

            links.find("li:first").should have_content(second)
            links.find("li:last").should have_content(first)
          end
        end
      end

      describe "#avatar_url" do
        let(:email) { "test@test.com" }

        it "returns gravatar url" do
          helper.avatar_url(email).should eq("http://gravatar.com/avatar/b642b4217b34b1e8d3bd915fc65c4452?s=60.jpg")
        end

        it "accepts options hash to change default size" do
          helper.avatar_url(email, :size => 55).should eq("http://gravatar.com/avatar/b642b4217b34b1e8d3bd915fc65c4452?s=55.jpg")
        end
      end
    end
  end
end
