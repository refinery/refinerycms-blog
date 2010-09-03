class BlogPost < ActiveRecord::Base

  has_many :comments, :class_name => 'BlogComment'
  has_and_belongs_to_many :categories, :class_name => 'BlogCategory'

  acts_as_indexed :fields => [:title, :body]

  validates_presence_of :title
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  default_scope :order => "created_at DESC"

  if Rails.version < '3.0.0'
    named_scope :live, :conditions => {:draft => false}
  else
    scope :live, :conditions => {:draft => false}
  end

  def category_ids=(ids)
    self.categories = ids.reject{|id| id.blank?}.collect {|c_id|
      BlogCategory.find(c_id.to_i) rescue nil
    }.compact
  end

  class << self
    def comments_allowed?
      RefinerySetting.find_or_set(:comments_allowed, true, {
        :scoping => :blog
      })
    end
  end

end
