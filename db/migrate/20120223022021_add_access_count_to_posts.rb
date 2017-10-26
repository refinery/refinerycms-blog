class AddAccessCountToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column Refinery::Blog::Post.table_name, :access_count, :integer, :default => 0

    add_index Refinery::Blog::Post.table_name, :access_count

  end
end
