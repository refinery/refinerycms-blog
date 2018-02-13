FactoryBot.define do
  factory :blog_comment, :class => Refinery::Blog::Comment do
    name "Joe Commenter"
    sequence(:email) { |n| "person#{n}@example.com" }
    body "Which one is the best for picking up new shoes?"
    association :post, :factory => :blog_post
  
    trait :approved do
      state 'approved'
    end
  
    trait :rejected do
      state 'rejected'
    end
    
    factory :approved_comment, :traits => [:approved]
    factory :rejected_comment, :traits => [:rejected]
  end
end
