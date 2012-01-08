module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                :title_attribute => :title,
                :order => 'title ASC'

      end
    end
  end
end
