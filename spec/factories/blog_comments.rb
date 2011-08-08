FactoryGirl.define do
  factory :blog_comment, :class => 'refinery/blog_comment' do
    name "Joe Commenter"
    sequence(:email) { |n| "person#{n}@example.com" }
    body "Which one is the best for picking up new shoes?"
    association :post, :factory => :blog_post
  end
end
