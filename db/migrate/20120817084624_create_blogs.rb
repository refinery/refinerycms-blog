class CreateBlogs < ActiveRecord::Migration

  def up
    create_table Refinery::Blog::Blog.table_name, :id => true do |t|
      t.string :name, :unique => true
      t.integer :position
      t.string :slug, :unique => true

      t.timestamps
    end
    Refinery::Blog::Blog.create_translation_table!
    ({
       :name => :string,
       :slug => :string
     })
    add_column(Refinery::Blog::Post.table_name,
               :blog_id, :integer)
    add_column(Refinery::Blog::Category.table_name,
               :blog_id, :integer)
  end

  def down
    Refinery::Blog::Blog.drop_translation_table!
    drop_table :refinery_blogs
  end

end
