class CreateBlogStructure < ActiveRecord::Migration

  def up
    create_table :refinery_blog_posts, :id => true do |t|
      t.string :title
      t.text :body
      t.boolean :draft
      t.datetime :published_at
      t.timestamps
    end

    add_index :refinery_blog_posts, :id

    create_table :refinery_blog_comments, :id => true do |t|
      t.integer :blog_post_id
      t.boolean :spam
      t.string :name
      t.string :email
      t.text :body
      t.string :state
      t.timestamps
    end

    add_index :refinery_blog_comments, :id
    add_index :refinery_blog_comments, :blog_post_id

    create_table :refinery_blog_categories, :id => true do |t|
      t.string :title
      t.timestamps
    end

    add_index :refinery_blog_categories, :id

    create_table :refinery_blog_categories_blog_posts, :id => true do |t|
      t.integer :blog_category_id
      t.integer :blog_post_id
    end

    add_index :refinery_blog_categories_blog_posts, [:blog_category_id, :blog_post_id], :name => 'index_blog_categories_blog_posts_on_bc_and_bp'
  end

  def down
    Refinery::UserPlugin.destroy_all({:name => "refinerycms_blog"}) if defined?(Refinery::UserPlugin)

    Refinery::Page.delete_all({:link_url => "/blog"}) if defined?(Refinery::Page)

    drop_table :refinery_blog_posts
    drop_table :refinery_blog_comments
    drop_table :refinery_blog_categories
    drop_table :refinery_blog_categories_blog_posts
  end

end
