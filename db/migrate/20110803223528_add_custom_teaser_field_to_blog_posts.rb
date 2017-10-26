class AddCustomTeaserFieldToBlogPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :refinery_blog_posts, :custom_teaser, :text
  end
end

