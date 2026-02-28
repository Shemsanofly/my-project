class PaymentTransaction < ApplicationRecord
  belongs_to :booking
  belongs_to :user

  enum status: {
    pending: "pending",
    succeeded: "succeeded",
    failed: "failed",
    cancelled: "cancelled"
  }

  validates :provider, :provider_payment_id, :status, :amount_cents, :currency, presence: true
end
