class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :itinerary
  belongs_to :tour, optional: true
  has_many :payment_transactions, dependent: :destroy

  enum status: {
    pending: "pending",
    confirmed: "confirmed",
    cancelled: "cancelled",
    paid: "paid"
  }

  validates :status, :start_date, :end_date, presence: true
end
