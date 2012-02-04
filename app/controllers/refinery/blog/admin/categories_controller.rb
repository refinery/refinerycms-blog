module Refinery
  module Blog
    module Admin
      class CategoriesController < ::Refinery::AdminController

        crudify :'refinery/blog/category',
                :order => 'title ASC'

      end
    end
  end
end
