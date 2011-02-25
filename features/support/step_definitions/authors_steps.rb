Given /^there is a user named "([^\"]*)"$/ do |login|
  @user = Factory.create(:user, :login => login, :password => "#{login}-123", :password_confirmation => "#{login}-123")
end

Then /^there should be (\d+) blog posts?$/ do |num|
  BlogPost.all.size == num
end

Then /^the blog post should belong to "([^\"]*)"$/ do |login|
  BlogPost.last.author.login == login
end