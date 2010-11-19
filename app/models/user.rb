class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  validates_length_of :login, :within => 3..40
  validates_uniqueness_of :login
  validates_format_of :login, :with => /\A[A-Za-z0-9]+\Z/

  validates_length_of :name, :maximum => 128
  validates_length_of :city, :maximum => 128
  validates_length_of :country, :maximum => 2
end
