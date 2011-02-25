Given /^there is a user named "([^\"]*)"$/ do |login|
  @user = Factory.create(:user, :login => login)
end

Then /^there should be (\d+) blog posts?$/ do |num|
  BlogPost.all.size == num
end

Then /^the blog post should belong to "([^\"]*)"$/ do |login|
  BlogPost.first.author.login == login
end