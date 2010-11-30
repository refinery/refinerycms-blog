class BlogPost < ActiveRecord::Base

  has_many :comments, :class_name => 'BlogComment'
  has_and_belongs_to_many :categories, :class_name => 'BlogCategory'

  acts_as_indexed :fields => [:title, :body]

  validates_presence_of :title
  validates_uniqueness_of :title

  has_friendly_id :title, :use_slug => true

  named_scope :by_archive, lambda { |archive_date| {:conditions => ['published_at between ? and ?', archive_date.beginning_of_month, archive_date.end_of_month], :order => "published_at DESC"} }

  named_scope :all_previous, :conditions => ['published_at <= ?', Time.now.beginning_of_month], :order => "published_at DESC"

  named_scope :live, lambda { {:conditions => ["published_at < ? and draft = ?", Time.now, false], :order => "published_at DESC"} }

  named_scope :previous, lambda { |i| { :conditions => ["published_at < ?", i.published_at], :order => "published_at DESC", :limit => 1 } }
  named_scope :next, lambda { |i| { :condtions => ["published_at > ?", i.published_at], :order => "published_at ASC", :limit => 1 } }

  def next
    self.class.next(self).first
  end

  def prev
    self.class.previous(self).first
  end

  def live?
    !draft and published_at <= Time.now
  end

  def category_ids=(ids)
    self.categories = ids.reject{|id| id.blank?}.collect {|c_id|
      BlogCategory.find(c_id.to_i) rescue nil
    }.compact
  end

  class << self
    def comments_allowed?
      RefinerySetting.find_or_set(:comments_allowed, true, {
        :scoping => 'blog'
      })
    end
  end

  module ShareThis
    DEFAULT_KEY = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    class << self
      def key
        RefinerySetting.find_or_set(:share_this_key, BlogPost::ShareThis::DEFAULT_KEY, {
          :scoping => 'blog'
        })
      end

      def enabled?
        key = BlogPost::ShareThis.key
        key.present? and key != BlogPost::ShareThis::DEFAULT_KEY
      end
    end
  end

end
