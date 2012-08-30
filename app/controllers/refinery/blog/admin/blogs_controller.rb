module Refinery
  module Blog
    module Admin
      class BlogsController < ::Refinery::AdminController

        crudify :'refinery/blog/blog',
                :title_attribute => 'name',
                :xhr_paging => true

      end
    end
  end
end
