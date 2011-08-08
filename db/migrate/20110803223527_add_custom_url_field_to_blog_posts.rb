class AddCustomUrlFieldToBlogPosts < ActiveRecord::Migration
  def change
    add_column Refinery::BlogPost.table_name, :custom_url, :string
  end
end
