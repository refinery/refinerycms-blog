class AddCachedSlugs < ActiveRecord::Migration
  def change
    add_column Refinery::BlogCategory.table_name, :cached_slug, :string
    add_column Refinery::BlogPost.table_name, :cached_slug, :string
  end
end
