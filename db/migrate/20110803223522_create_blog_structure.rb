class CreateBlogStructure < ActiveRecord::Migration

  def up
    create_table :refinery_blog_posts do |t|
      t.string :title
      t.text :body
      t.boolean :draft
      t.datetime :published_at
      t.integer :user_id
      t.string :slug
      t.string :custom_url
      t.text :custom_teaser
      t.string :source_url
      t.string :source_url_title
      t.integer :access_count, :default => 0
      t.timestamps
    end

    add_index :refinery_blog_posts, :id
    add_index :refinery_blog_posts, :access_count
    add_index :refinery_blog_posts, :slug

    create_table :refinery_blog_comments do |t|
      t.integer :blog_post_id
      t.boolean :spam
      t.string :name
      t.string :email
      t.text :body
      t.string :state
      t.timestamps
    end

    add_index :refinery_blog_comments, :id

    create_table :refinery_blog_categories do |t|
      t.string :title
      t.string :slug
      t.timestamps
    end

    add_index :refinery_blog_categories, :id
    add_index :refinery_blog_categories, :slug

    create_table :refinery_blog_categories_blog_posts do |t|
      t.primary_key :id
      t.integer :blog_category_id
      t.integer :blog_post_id
    end

    add_index :refinery_blog_categories_blog_posts, [:blog_category_id, :blog_post_id], :name => 'index_blog_categories_blog_posts_on_bc_and_bp'

    Refinery::Blog::Post.create_translation_table!({
      :body => :text,
      :custom_teaser => :text,
      :custom_url => :string,
      :slug => :string,
      :title => :string
    })
    Refinery::Blog::Category.create_translation_table!({
      :title => :string,
      :slug => :string
    })
  end

  def down
    Refinery::UserPlugin.destroy_all({:name => "refinerycms_blog"})

    Refinery::Page.delete_all({:link_url => "/blog"})

    drop_table :refinery_blog_posts
    drop_table :refinery_blog_comments
    drop_table :refinery_blog_categories
    drop_table :refinery_blog_categories_blog_posts

    Refinery::Blog::Post.drop_translation_table!
    Refinery::Blog::Category.drop_translation_table!
  end

end
