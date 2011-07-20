class AddCustomTeaserSourceToBlogPost < ActiveRecord::Migration
  def self.up
    add_column :blog_posts, :custom_teaser_source, :text, :null => true
  end

  def self.down
    remove_column :blog_posts, :custom_teaser_source
  end
end
