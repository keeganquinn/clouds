class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :followed, class_name: 'User', foreign_key: 'follow_user_id'

  attr_accessible :follow_user_id

  validates_presence_of :user
  validates_presence_of :followed
  validates_uniqueness_of :follow_user_id, scope: :user_id
end
