Factory.define(:blog_category) do |f|
  f.title "Shopping"
  f.posts {|p| [p.association(:post)]}
end