class BlogComment < ActiveRecord::Base

  belongs_to :post, :class_name => 'BlogPost'

  acts_as_indexed :fields => [:name, :email, :body]

  named_scope :approved, :conditions => {:approved => true}
  named_scope :rejected, :conditions => {:approved => false}
end
