Then /^there should be (\d+) blog posts?$/ do |num|
  ::Refinery::BlogPost.all.size == num
end

Then /^the blog post should belong to me$/ do
  ::Refinery::BlogPost.first.author.login == ::Refinery::User.last.login
end