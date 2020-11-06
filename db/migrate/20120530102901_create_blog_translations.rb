class CreateBlogTranslations < ActiveRecord::Migration[4.2]
  def change
    create_table :refinery_blog_post_translations do |t|

      # Translated attribute(s)
      t.text :body
      t.text :custom_teaser
      t.string :custom_url
      t.string :slug
      t.string :title

      t.string  :locale, null: false
      t.integer :refinery_blog_post_id, null: false

      t.timestamps null: false
    end

    add_index :refinery_blog_post_translations, :locale, name: :index_refinery_blog_post_translations_on_locale
    add_index :refinery_blog_post_translations, [:refinery_blog_post_id, :locale], name: :index_refinery_b_p_t10s_on_refinery_blog_post_id_and_locale, unique: true
  end
end
