class RemoveTranslatedColumnsToRefineryBlogCategories < ActiveRecord::Migration[5.1]
  def change
    remove_column :refinery_blog_categories, :title
  end
end
