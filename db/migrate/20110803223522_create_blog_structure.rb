class CreateBlogStructure < ActiveRecord::Migration

  def up
    create_table Refinery::Blog::Post.table_name, :id => true do |t|
      t.string :title
      t.text :body
      t.boolean :draft
      t.datetime :published_at
      t.timestamps
    end

    add_index Refinery::Blog::Post.table_name, :id

    create_table Refinery::Blog::Comment.table_name, :id => true do |t|
      t.integer :blog_post_id
      t.boolean :spam
      t.string :name
      t.string :email
      t.text :body
      t.string :state
      t.timestamps
    end

    add_index Refinery::Blog::Comment.table_name, :id

    create_table Refinery::Blog::Category.table_name, :id => true do |t|
      t.string :title
      t.timestamps
    end

    add_index Refinery::Blog::Category.table_name, :id

    create_table Refinery::Categorization.table_name, :id => true do |t|
      t.integer :blog_category_id
      t.integer :blog_post_id
    end

    add_index Refinery::Categorization.table_name, [:blog_category_id, :blog_post_id], :name => 'index_blog_categories_blog_posts_on_bc_and_bp'
  end

  def down
    Refinery::UserPlugin.destroy_all({:name => "refinerycms_blog"})

    Refinery::Page.delete_all({:link_url => "/blog"})

    drop_table Refinery::Blog::Post.table_name
    drop_table Refinery::Blog::Comment.table_name
    drop_table Refinery::Blog::Category.table_name
    drop_table Refinery::Categorization.table_name
  end

end
