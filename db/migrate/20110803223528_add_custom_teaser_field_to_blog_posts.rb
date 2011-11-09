class AddCustomTeaserFieldToBlogPosts < ActiveRecord::Migration
  def change
    add_column Refinery::Blog::Post.table_name, :custom_teaser, :text
  end
end

