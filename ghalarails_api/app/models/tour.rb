class Tour < ApplicationRecord
  has_many :bookings, dependent: :nullify

  validates :title, :price, :duration_days, :trip_type, presence: true
end
