class PostAttachment < ActiveRecord::Base
  belongs_to :post

  default_scope order: 'created_at DESC'

  attr_accessible :filename, :content_type, :data

  validates_presence_of :post

  validates_length_of :filename, within: 3..128
  validates_uniqueness_of :filename, scope: :post_id
  validates_format_of :filename, with: /\A[.A-Za-z0-9_-]+\Z/

  validates_length_of :content_type, within: 3..128

  validates_presence_of :data

  def to_param
    filename
  end

  def self.find_by_param(param)
    self.find_by_filename(param)
  end
end
