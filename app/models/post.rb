class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_attachments

  belongs_to :in_reply_to_post, class_name: "Post"
  has_many :replies, class_name: "Post", foreign_key: "in_reply_to_post_id"

  default_scope order: 'created_at DESC'
  scope :top, where('in_reply_to_post_id IS NULL')

  attr_accessible :in_reply_to_post_id, :code, :subject, :body, :published

  define_index do
    indexes code, sortable: true
    indexes subject, sortable: true
    indexes body
    indexes post_attachments.filename, as: :attachments

    has user_id, in_reply_to_post_id, created_at, updated_at
  end

  validates :user, presence: true

  validates :code, length: { within: 3..255 }
  validates :code, uniqueness: { scope: :user_id }
  validates :code, format: { with: /\A[A-Za-z0-9_-]+\Z/ }

  validates :subject, length: { within: 3..255 }
  validates :body, presence: true

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
