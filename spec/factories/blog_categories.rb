FactoryGirl.define do
  factory :blog_category, :class => Refinery::BlogCategory do
    sequence(:title) { |n| "Shopping #{n}" }
  end
end
