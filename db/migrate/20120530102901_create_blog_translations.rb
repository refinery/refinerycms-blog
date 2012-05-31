class CreateBlogTranslations < ActiveRecord::Migration
  def up
    Refinery::Blog::Post.create_translation_table!({
                                                     body: :text,
                                                     custom_teaser: :text,
                                                     custom_url: :string,
                                                     slug: :string,
                                                     title: :string,
                                                   })
  end

  def down
    Refinery::Blog::Post.drop_translation_table!    
  end
end
