module Refinery
  module Blog
    class Categorization < ActiveRecord::Base

      self.table_name = 'refinery_blog_categories_blog_posts'
      belongs_to :blog_post, :class_name => 'Refinery::Blog::Post', :foreign_key => :blog_post_id
      belongs_to :blog_category, :class_name => 'Refinery::Blog::Category', :foreign_key => :blog_category_id

    end
  end
end
