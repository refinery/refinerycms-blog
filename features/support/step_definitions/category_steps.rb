Given /^there is a category titled "([^"]*)"$/ do |title|
  @category = Factory(:blog_category, :title => title)
end

Then /^the blog post should have "([^"]*)" category$/ do |num_category|
  BlogPost.last.categories.count.should == num_category
end

Then /^the blog post should have the category "([^"]*)"$/ do |category| 
  BlogPost.last.categories.first.title.should == category
end