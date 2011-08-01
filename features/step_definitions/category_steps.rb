Given /^there is a category titled "([^"]*)"$/ do |title|
  @category = Factory.create(:blog_category, :title => title)
end

Then /^the blog post should have ([\d]*) categor[yies]{1,3}$/ do |num_category|
  ::Refinery::BlogPost.last.categories.count.should == num_category.to_i
end

Then /^the blog post should have the category "([^"]*)"$/ do |category|
  ::Refinery::BlogPost.last.categories.first.title.should == category
end
