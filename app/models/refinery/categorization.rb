module Refinery
  class Categorization < ActiveRecord::Base

    set_table_name 'refinery_blog_categories_blog_posts'
    belongs_to :blog_post
    belongs_to :blog_category

  end
end