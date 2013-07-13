class AddUserIdToBlogPosts < ActiveRecord::Migration

  def change
    add_column :refinery_blog_posts, :user_id, :integer
  end

end
