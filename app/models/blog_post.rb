class BlogPost < ActiveRecord::Base

  has_many :comments, :class_name => 'BlogComment'
  has_and_belongs_to_many :categories, :class_name => 'BlogCategory'

  acts_as_indexed :fields => [:title, :body]

  validates_presence_of :title
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  default_scope :order => "created_at DESC"

  named_scope :live, :conditions => {:draft => false}

  def category_ids=(ids)
    self.categories.clear

    self.categories += ids.reject{|id| id.blank?}.collect {|c_id|
      category = Category.find(category_id.to_i) rescue nil
    }.compact
  end

end
