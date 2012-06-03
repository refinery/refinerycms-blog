class DeleteCachedSlugs < ActiveRecord::Migration
  def change
    remove_column Refinery::Blog::Category.table_name, :cached_slug
    remove_column Refinery::Blog::Post.table_name, :cached_slug
  end
end
