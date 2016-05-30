FactoryGirl.define do
  factory :author, class: Refinery::Authentication::Devise::User do
    sequence(:username) { |n| "refinery#{n}" }
    sequence(:email) { |n| "refinery#{n}@example.com" }
    password  "refinerycms"
    password_confirmation "refinerycms"
  end
end
