class AddPrimaryKeyToCategorizations < ActiveRecord::Migration
  def up
    unless Refinery::Blog::Categorization.column_names.include?("id")
      add_column Refinery::Blog::Categorization.table_name, :id, :primary_key
    end
  end

  def down
    if Refinery::Blog::Categorization.column_names.include?("id")
      remove_column Refinery::Blog::Categorization.table_name, :id
    end
  end
end

