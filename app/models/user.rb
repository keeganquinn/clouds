class User < ActiveRecord::Base
  has_many :posts

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :name, :city, :country, :content

  validates_length_of :username, :within => 3..40, :allow_nil => true
  validates_uniqueness_of :username, :allow_nil => true
  validates_format_of :username, :with => /\A[A-Za-z0-9]+\Z/, :allow_nil => true

  validates_length_of :name, :maximum => 128
  validates_length_of :city, :maximum => 128
  validates_length_of :country, :maximum => 2

  def to_param
    "#{username.blank? ? id : username}"
  end

  def self.find_by_param(param)
    self.find_by_username(param) || self.find(param)
  end
end
