
FactoryGirl.define do
  factory :blog, :class => Refinery::Blog::Blog do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

