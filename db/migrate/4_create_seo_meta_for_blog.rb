class CreateSeoMetaForBlog < ActiveRecord::Migration

  def up
    unless ::SeoMetum.table_exists?
      create_table ::SeoMetum.table_name do |t|
        t.integer :seo_meta_id
        t.string :seo_meta_type

        t.string :browser_title
        t.string :meta_keywords
        t.text :meta_description

        t.timestamps
      end

      add_index ::SeoMetum.table_name, :id
      add_index ::SeoMetum.table_name, [:seo_meta_id, :seo_meta_type]
    end
  end

  def down
    # can't drop the table because someone else might be using it.
  end

end
