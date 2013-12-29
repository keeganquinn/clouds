class PostAttachment < ActiveRecord::Base
  belongs_to :post

  default_scope -> { order 'created_at DESC' }

  attr_accessible :filename, :content_type, :data

  validates :post, presence: true

  validates :filename, length: { within: 3..128 }
  validates :filename, uniqueness: { scope: :post_id }
  validates :filename, format: { with: /\A[.A-Za-z0-9_-]+\Z/ }

  validates :content_type, length: { within: 3..128 }

  validates :data, presence: true

  def to_param
    filename
  end

  def self.find_by_param(param)
    self.find_by_filename(param)
  end
end
