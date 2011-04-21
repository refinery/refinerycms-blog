class AddTitleToCategorization < ActiveRecord::Migration
  def self.up
    add_column :blog_categories_blog_posts, :title, :string, :null => false
  end

  def self.down
    remove_column :blog_categories_blog_posts, :title
  end
end
