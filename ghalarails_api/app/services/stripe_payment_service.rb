class StripePaymentService
  class ServiceError < StandardError; end

  def create_payment_intent(amount_cents:, currency:, metadata: {})
    raise ServiceError, "Stripe is not configured" if ENV["STRIPE_SECRET_KEY"].blank?

    Stripe::PaymentIntent.create(
      amount: amount_cents,
      currency: currency,
      automatic_payment_methods: { enabled: true },
      metadata: metadata
    )
  rescue StandardError => error
    raise ServiceError, "Stripe payment intent failed: #{error.message}"
  end

  def parse_webhook(payload, signature)
    webhook_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET")

    Stripe::Webhook.construct_event(payload, signature, webhook_secret)
  rescue KeyError => error
    raise ServiceError, "Missing configuration: #{error.message}"
  rescue StandardError => error
    raise ServiceError, "Invalid Stripe webhook: #{error.message}"
  end
end
