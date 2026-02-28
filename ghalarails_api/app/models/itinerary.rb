class Itinerary < ApplicationRecord
  belongs_to :user, optional: true
  has_many :bookings, dependent: :nullify

  enum trip_type: {
    honeymoon: "honeymoon",
    family: "family",
    adventure: "adventure",
    solo: "solo",
    luxury: "luxury",
    budget: "budget"
  }

  validates :days, :budget, :trip_type, :content, presence: true
end
