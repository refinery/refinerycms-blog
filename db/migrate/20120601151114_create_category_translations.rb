class CreateCategoryTranslations < ActiveRecord::Migration[4.2]
  def change
    create_table :refinery_blog_category_translations do |t|

      # Translated attribute(s)
      t.string :title
      t.string :slug
    
      t.string  :locale, null: false
      t.integer :refinery_blog_category_id, null: false
    
      t.timestamps null: false
    end
    
    add_index :refinery_blog_category_translations, :locale, name: :index_refnery_blog_category_translations_on_locale
    add_index :refinery_blog_category_translations, [:refinery_blog_category_id, :locale], name: :index_refinery_b_c_t_on_refinery_blog_category_id_and_locale, unique: true
  end
end
