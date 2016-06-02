class AddUsernameToBlogPosts < ActiveRecord::Migration
  def change
    add_column :refinery_blog_posts, :username, :string
  end
end