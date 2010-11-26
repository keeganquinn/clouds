class Post < ActiveRecord::Base
  belongs_to :user

  belongs_to :in_reply_to_post, :class_name => "Post"
  has_many :replies, :class_name => "Post",
    :foreign_key => "in_reply_to_post_id"

  attr_accessible :in_reply_to_post_id, :code, :subject, :body, :published

  validates_length_of :code, :within => 3..255
  validates_uniqueness_of :code
  validates_format_of :code, :with => /\A[A-Za-z0-9_-]+\Z/

  validates_length_of :subject, :within => 3..255
  validates_presence_of :body

  def to_param
    code.blank? ? id : code
  end

  def self.find_by_param(param)
    self.find_by_code(param) || self.find(param)
  end
end
