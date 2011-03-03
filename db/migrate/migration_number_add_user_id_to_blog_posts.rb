class AddUserIdToBlogPosts < ActiveRecord::Migration
  
  def self.up
    add_column :blog_posts, :user_id, :integer
  end
  
  def self.down
    remove_column :blog_posts, :user_id
  end
  
end