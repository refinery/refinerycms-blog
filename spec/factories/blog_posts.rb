FactoryGirl.define do
  factory :blog_post, :class => Refinery::Blog::Post do
    sequence(:title) { |n| "Top #{n} Shopping Centers in Chicago" }
    body "These are the top ten shopping centers in Chicago. You're going to read a long blog post about them. Come to peace with it."
    draft false
    published_at Time.now
    author { FactoryGirl.create(:authentication_devise_refinery_user) }

    factory :blog_post_draft do
      draft true
    end
  end
end
