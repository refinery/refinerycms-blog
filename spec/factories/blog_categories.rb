FactoryBot.define do
  factory :blog_category, class: Refinery::Blog::Category do
    sequence(:title) { |n| "Shopping #{n}" }
  end
end
