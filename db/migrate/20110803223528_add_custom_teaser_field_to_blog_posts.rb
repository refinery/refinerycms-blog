class AddCustomTeaserFieldToBlogPosts < ActiveRecord::Migration
  def change
    add_column Refinery::BlogPost.table_name, :custom_teaser, :text
  end
end

