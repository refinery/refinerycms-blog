class CreateCategoryTranslations < ActiveRecord::Migration
  def up
    Refinery::Blog::Category.create_translation_table!({
                                                         title: :string,
                                                         slug: :string
                                                       })
  end

  def down
    Refinery::Blog::Category.drop_translation_table!
  end
end
