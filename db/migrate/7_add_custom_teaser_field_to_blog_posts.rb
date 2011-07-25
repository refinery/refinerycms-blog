class AddCustomTeaserFieldToBlogPosts < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :custom_teaser, :text
  end

  def self.down
    remove_column :blog_posts, :custom_teaser
  end
end

