require 'factory_girl'

Factory.define :blog_comment, :class => 'refinery/blog_comment' do |f|
  f.name "Joe Commenter"
  f.sequence(:email) { |n| "person#{n}@example.com" }
  f.body "Which one is the best for picking up new shoes?"
  f.association :post, :factory => :blog_post
end
