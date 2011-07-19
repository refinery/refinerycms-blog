Given /^the RefinerySetting (.*?) is (.*?) for scoping (.*?)$/ do |setting,value, scoping|
  r = RefinerySetting.create(:name => setting, :value => value == "true", :scoping => scoping)
end

Then /^there (should|should not) be a (.*?) class on the (.*?) element$/ do |yes_or_no, css_class, element_selector|
  complete_selector = "#{element_selector}.#{css_class}"
  if yes_or_no == "should"
    page.should have_css(complete_selector)
  else
    page.should_not have_css(complete_selector)
  end
end

Then /^the first blog post should have a textile_body field containing "([^"]*)"$/ do |expected_content|
  BlogPost.first.textile_body.should == expected_content
end

Then /^the first blog post should have a body field containing "([^"]*)"$/ do |expected_content|
  BlogPost.first.body.should == expected_content
end

Then /^there (should|should not) be a "([^"]*)" link$/ do |yes_or_no, link|
  if yes_or_no == "should"
    page.should have_link(link)
  else
    page.should_not have_link(link)
  end
end
