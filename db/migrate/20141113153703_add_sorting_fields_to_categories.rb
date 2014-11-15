class AddSortingFieldsToCategories < ActiveRecord::Migration

  def change
    add_column :refinery_blog_categories, :position, :integer
    
    add_column :refinery_blog_categories, :parent_id, :integer
    add_column :refinery_blog_categories, :lft, :integer
    add_column :refinery_blog_categories, :rgt, :integer
    add_column :refinery_blog_categories, :depth, :integer
    
    
    add_index :refinery_blog_categories, :position
    add_index :refinery_blog_categories, :parent_id
    add_index :refinery_blog_categories, :lft
    add_index :refinery_blog_categories, :rgt
    add_index :refinery_blog_categories, :depth
    
  end

end
