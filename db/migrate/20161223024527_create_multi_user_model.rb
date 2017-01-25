class CreateMultiUserModel < ActiveRecord::Migration
  def up
    return unless Rails.env.test?
    create_table :refinery_blog_test_users do |t|
      t.string :username
    end
  end

  def down
    return unless Rails.env.test?
    drop_table :refinery_blog_test_users
  end
end
