class CreateBlogTranslations < ActiveRecord::Migration[4.2]
  def up
    create_table :refinery_blog_post_translations do |t|
      t.text :body
      t.text :custom_teaser
      t.string :custom_url
      t.string :slug
      t.string :title

      t.string :locale, null: false
      t.integer :refinery_blog_post_id, null: false

      t.timestamps null: false
    end
    add_index :refinery_blog_post_translations, :locale, name: :index_refinery_blog_post_translations_on_locale
    add_index :refinery_blog_post_translations, [:refinery_blog_post_id, :locale], name: :index_refinery_blog_post_tx_on_refinery_blog_post_id_locale, unique: true
  end

  def down
    drop_table :refinery_blog_post_translations
  end
end
