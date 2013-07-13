class AddCustomTeaserFieldToBlogPosts < ActiveRecord::Migration
  def change
    add_column :refinery_blog_posts, :custom_teaser, :text
  end
end

