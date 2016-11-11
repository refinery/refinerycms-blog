class DeleteCachedSlugs < ActiveRecord::Migration
  def change
    remove_column Refinery::Blog::Category.table_name, :cached_slug, :string
    remove_column Refinery::Blog::Post.table_name, :cached_slug, :string
  end
end
