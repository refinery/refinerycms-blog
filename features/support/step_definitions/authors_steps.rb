Then /^there should be (\d+) blog posts?$/ do |num|
  BlogPost.all.size == num
end

Then /^the blog post should belong to me$/ do
  BlogPost.first.author.login == User.last.login
end