class AddCustomUrlFieldToBlogPosts < ActiveRecord::Migration
  def change
    add_column :refinery_blog_posts, :custom_url, :string
  end
end
