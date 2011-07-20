Given /^the RefinerySetting (.*?) is (.*?) for scoping (.*?)$/ do |setting,value, scoping|
  r = RefinerySetting.create(:name => setting, :value => value, :scoping => scoping)
  RefinerySetting.rewrite_cache
end

Then /^there (should|should not) be a (.*?) class on the (.*?) element$/ do |yes_or_no, css_class, element_selector|
  complete_selector = "#{element_selector}.#{css_class}"
  if yes_or_no == "should"
    page.should have_css(complete_selector)
  else
    page.should_not have_css(complete_selector)
  end
end

Then /^the first blog post should have a body_source field containing "([^"]*)"$/ do |expected_content|
  BlogPost.first.body_source.strip.should == expected_content.strip
end

Then /^the first blog post should have a body field containing "([^"]*)"$/ do |expected_content|
  BlogPost.first.body.strip.should == expected_content.strip
end

Then /^there (should|should not) be a "([^"]*)" link$/ do |yes_or_no, link|
  if yes_or_no == "should"
    page.should have_link(link)
  else
    page.should_not have_link(link)
  end
end
