class User < ApplicationRecord 
  validates_presence_of :name, :address, :city, :state, :zip

  validates_presence_of :password, require: true, confirmation: true, allow_nil: true
  validates_confirmation_of :password
  validates :email, uniqueness: true, presence: true

  has_many :orders

  has_secure_password

  enum role: {regular: 0, merchant: 1, admin: 2}
end