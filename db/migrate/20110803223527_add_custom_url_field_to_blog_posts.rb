class AddCustomUrlFieldToBlogPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :refinery_blog_posts, :custom_url, :string
  end
end
