class AddPrimaryKeyToCategorizations < ActiveRecord::Migration
  def self.up
    unless ::Categorization.column_names.include?("id")
      add_column :blog_categories_blog_posts, :id, :primary_key
    end
  end

  def self.down
    remove_column :blog_categories_blog_posts, :id
  end
end

