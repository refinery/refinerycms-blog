Factory.define(:blog_category) do |f|
  f.sequence(:title) { |n| "Shopping #{n}" }
  f.posts {|p| [p.association(:post)]}
end
