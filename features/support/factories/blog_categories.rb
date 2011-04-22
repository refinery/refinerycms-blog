require 'factory_girl'

Factory.define(:blog_category) do |f|
  f.sequence(:title) { |n| "Shopping #{n}" }
end
