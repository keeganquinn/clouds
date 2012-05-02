class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :followed, class_name: 'User', foreign_key: 'follow_user_id'

  attr_accessible :follow_user_id

  validates :user, presence: true
  validates :followed, presence: true
  validates :follow_user_id, uniqueness: { scope: :user_id }
end
