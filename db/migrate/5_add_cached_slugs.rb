class AddCachedSlugs < ActiveRecord::Migration
  def self.up
    add_column :blog_categories, :cached_slug, :string
    add_column :blog_posts, :cached_slug, :string
  end

  def self.down
    remove_column :blog_categories, :cached_slug
    remove_column :blog_posts, :cached_slug
  end
end
