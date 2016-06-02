if defined?(Refinery::Authentication::Devise::User)
  FactoryGirl.define do
    factory :authentication_devise_user, :class => Refinery::Authentication::Devise::User do
      sequence(:username) { |n| "refinery#{n}" }
      sequence(:email) { |n| "refinery#{n}@example.com" }
      password  "refinerycms"
      password_confirmation "refinerycms"
    end

    factory :authentication_devise_refinery_user, :parent => :authentication_devise_user do
      roles { [ ::Refinery::Authentication::Devise::Role[:refinery] ] }

      after(:create) do |user|
        ::Refinery::Plugins.registered.each_with_index do |plugin, index|
          user.plugins.create(:name => plugin.name, :position => index)
        end
      end
    end

    factory :authentication_devise_refinery_superuser, :parent => :authentication_devise_refinery_user do
      roles {
        [
          ::Refinery::Authentication::Devise::Role[:refinery],
          ::Refinery::Authentication::Devise::Role[:superuser]
        ]
      }
    end
  end
end