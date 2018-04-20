class RemoveTranslatedColumnsToRefineryBlogCategories < ActiveRecord::Migration
  def change
    remove_column :refinery_blog_categories, :title
  end
end
