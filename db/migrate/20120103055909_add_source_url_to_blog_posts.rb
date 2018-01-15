class AddSourceUrlToBlogPosts < ActiveRecord::Migration[4.2]
  def change
    add_column Refinery::Blog::Post.table_name, :source_url, :string
    add_column Refinery::Blog::Post.table_name, :source_url_title, :string

  end
end
