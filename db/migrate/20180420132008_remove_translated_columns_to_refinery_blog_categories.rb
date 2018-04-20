class RemoveTranslatedColumnsToRefineryBlogCategories < ActiveRecord::Migration
  def change
    remove_column :refinery_blog_categories, :title
    remove_column :refinery_blog_categories, :slug
  end
end
