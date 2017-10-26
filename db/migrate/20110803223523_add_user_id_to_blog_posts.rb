class AddUserIdToBlogPosts < ActiveRecord::Migration[4.2]

  def change
    add_column :refinery_blog_posts, :user_id, :integer
  end

end
