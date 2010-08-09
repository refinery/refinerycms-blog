class BlogComment < ActiveRecord::Base

  belongs_to :post, :class_name => 'BlogPost'

  acts_as_indexed :fields => [:name, :email, :body]

  validates_presence_of :title
  validates_uniqueness_of :title

  named_scope :approved, :conditions => {:approved => true}
  named_scope :rejected, :conditions => {:approved => false}
end
