class CreateBlogTranslations < ActiveRecord::Migration[4.2]
  def up
    Refinery::Blog::Post.create_translation_table!({
      :body => :text,
      :custom_teaser => :text,
      :custom_url => :string,
      :slug => :string,
      :title => :string
    }, {
      :migrate_data => true
    })
  end

  def down
    Refinery::Blog::Post.drop_translation_table! :migrate_data => true
  end
end
