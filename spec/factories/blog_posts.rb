FactoryGirl.define do
  factory :blog_post, :class => 'refinery/blog_post' do
    sequence(:title) { |n| "Top #{n} Shopping Centers in Chicago" }
    body "These are the top ten shopping centers in Chicago. You're going to read a long blog post about them. Come to peace with it."
    draft false
    tag_list "chicago, shopping, fun times"
    published_at Time.now
  end
end
