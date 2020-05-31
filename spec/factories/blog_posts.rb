FactoryBot.define do
  factory :blog_post, :class => Refinery::Blog::Post do
    sequence(:title) { |n| "Top #{n} Shopping Centers in Chicago" }
    body { "These are the top ten shopping centers in Chicago. You're going to read a long blog post about them. Come to peace with it." }
    draft { false }
    published_at { Time.now }
    username { "John Doe" }

    factory :blog_post_draft do
      draft { true }
    end

    factory :blog_post_authentication_devise_refinery_user_author do
      author { FactoryBot.create(:blog_test_user) }
    end
  end
end
