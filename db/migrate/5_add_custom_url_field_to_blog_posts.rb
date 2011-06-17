class AddCustomUrlFieldToBlogPosts < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :custom_url, :string
  end

  def self.down
    remove_column :blog_posts, :custom_url
  end
end
