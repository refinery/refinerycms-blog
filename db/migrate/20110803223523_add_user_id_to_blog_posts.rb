class AddUserIdToBlogPosts < ActiveRecord::Migration

  def change
    add_column Refinery::BlogPost.table_name, :user_id, :integer
  end

end