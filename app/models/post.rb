class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_attachments

  belongs_to :in_reply_to_post, class_name: "Post"
  has_many :replies, class_name: "Post", foreign_key: "in_reply_to_post_id"

  default_scope order: 'created_at DESC'
  scope :top, where('in_reply_to_post_id IS NULL')

  attr_accessible :in_reply_to_post_id, :code, :subject, :body, :published

  validates_presence_of :user

  validates_length_of :code, within: 3..255
  validates_uniqueness_of :code, scope: :user_id
  validates_format_of :code, with: /\A[A-Za-z0-9_-]+\Z/

  validates_length_of :subject, within: 3..255
  validates_presence_of :body

  def to_param
    code
  end

  def self.find_by_param(param)
    self.find_by_code(param)
  end

  before_validation :set_defaults, on: :create

  def set_defaults
    if self.code.blank?
      self.code = self.subject ? self.subject.parameterize : ''
    end
  end
end
