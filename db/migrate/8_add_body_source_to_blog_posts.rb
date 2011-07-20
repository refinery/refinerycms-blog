class AddTextileBodyToBlogPosts < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :body_source, :text, :null => true
  end

  def self.down
    remove_column :blog_posts, :body_source
  end
end
