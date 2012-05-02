class User < ActiveRecord::Base
  has_many :posts
  has_many :follows, dependent: :destroy
  has_many :followed_users, through: :follows, source: :followed

  has_many :followers, foreign_key: 'follow_user_id', class_name: 'Follow', dependent: :destroy
  has_many :follower_users, through: :followers, source: :user

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable

  default_scope order: 'username ASC'

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :name, :location, :content

  validates :username, length: { within: 3..40 }
  validates :username, uniqueness: true
  validates :username, format: { with: /\A[A-Za-z0-9]+\Z/ }

  validates :name, length: { maximum: 128 }
  validates :location, length: { maximum: 128 }

  def following?(other_user)
    follows.find_by_follow_user_id(other_user.id)
  end

  def follow!(other_user)
    follows.create!(follow_user_id: other_user.id)
  end

  def unfollow!(other_user)
    follows.find_by_follow_user_id(other_user.id).destroy
  end

  def to_param
    username
  end

  def self.find_by_param(param)
    self.find_by_username(param)
  end
end
