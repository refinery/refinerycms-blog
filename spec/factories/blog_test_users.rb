require File.expand_path('../support/refinery_blog_test_user', __dir__)

FactoryBot.define do
  factory :blog_test_user, class: Refinery::Blog::TestUser do
  end
end
