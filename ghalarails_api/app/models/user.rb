class User < ApplicationRecord
  has_secure_password

  has_many :itineraries, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :payment_transactions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
