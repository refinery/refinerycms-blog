class BlogComment < ActiveRecord::Base

  acts_as_indexed :fields => [:name, :email, :body]

  validates_presence_of :title
  validates_uniqueness_of :title

end
