class CreateBlogStructure < ActiveRecord::Migration

  def self.up
    create_table :blog_posts, :id => true do |t|
      t.string :title
      t.text :body
      t.boolean :draft
      t.datetime :published_at
      t.timestamps
    end

    add_index :blog_posts, :id

    create_table :blog_comments, :id => true do |t|
      t.integer :blog_post_id
      t.boolean :spam
      t.string :name
      t.string :email
      t.text :body
      t.string :state
      t.timestamps
    end

    add_index :blog_comments, :id

    create_table :blog_categories, :id => true do |t|
      t.string :title
      t.timestamps
    end

    add_index :blog_categories, :id

    create_table :blog_categories_blog_posts, :id => true do |t|
      t.integer :blog_category_id
      t.integer :blog_post_id
    end

    add_index :blog_categories_blog_posts, [:blog_category_id, :blog_post_id], :name => 'index_blog_categories_blog_posts_on_bc_and_bp'

    load(Rails.root.join('db', 'seeds', 'refinerycms_blog.rb').to_s)
  end

  def self.down
    UserPlugin.destroy_all({:name => "refinerycms_blog"})

    Page.delete_all({:link_url => "/blog"})

    drop_table :blog_posts
    drop_table :blog_comments
    drop_table :blog_categories
    drop_table :blog_categories_blog_posts
  end

end
