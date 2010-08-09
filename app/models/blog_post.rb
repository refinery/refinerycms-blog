class BlogPost < ActiveRecord::Base

  acts_as_indexed :fields => [:title, :body]

  validates_presence_of :title
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  default_scope :order => "created_at DESC"

  named_scope :live, :conditions => {:draft => false}

end
