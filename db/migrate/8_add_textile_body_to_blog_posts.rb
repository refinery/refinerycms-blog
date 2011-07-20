class AddTextileBodyToBlogPosts < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :textile_body, :text, :null => true
  end

  def self.down
    remove_column :blog_posts, :textile_body
  end
end
