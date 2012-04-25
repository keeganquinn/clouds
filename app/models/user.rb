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

  validates_length_of :username, within: 3..40
  validates_uniqueness_of :username
  validates_format_of :username, with: /\A[A-Za-z0-9]+\Z/

  validates_length_of :name, maximum: 128
  validates_length_of :location, maximum: 128

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
