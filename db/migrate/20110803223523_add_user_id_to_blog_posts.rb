class AddUserIdToBlogPosts < ActiveRecord::Migration

  def change
    add_column Refinery::Blog::Post.table_name, :user_id, :integer
  end

end