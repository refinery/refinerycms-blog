Factory.define(:post, :class => BlogPost) do |f|
  f.sequence(:title) { |n| "Top #{n} Shopping Centers in Chicago" }
  f.body "These are the top ten shopping centers in Chicago. You're going to read a long blog post about them. Come to peace with it."
  f.draft false
  f.published_at Time.now
end
