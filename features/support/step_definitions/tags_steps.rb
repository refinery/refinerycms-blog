Then /^the blog post should have the tags "([^"]*)"$/ do |tag_list|
  BlogPost.last.tag_list == tag_list.split(', ')
end
