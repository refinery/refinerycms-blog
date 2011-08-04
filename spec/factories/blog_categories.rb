FactoryGirl.define do
  factory :blog_category, :class => 'refinery/blog_category' do
    sequence(:title) { |n| "Shopping #{n}" }
  end
end
