module Api
  module V1
    class PaymentsController < ApplicationController
      before_action :authenticate_user!, except: %i[webhook]

      def create_intent
        booking = current_user.bookings.find(params.require(:booking_id))
        payment = StripePaymentService.new.create_payment_intent(
          amount_cents: (booking.total_amount * 100).to_i,
          currency: "usd",
          metadata: {
            booking_id: booking.id,
            user_id: current_user.id
          }
        )

        transaction = PaymentTransaction.create!(
          booking: booking,
          user: current_user,
          provider: "stripe",
          provider_payment_id: payment.id,
          status: "pending",
          amount_cents: payment.amount,
          currency: payment.currency,
          metadata: {
            client_secret_present: payment.client_secret.present?
          }
        )

        render json: {
          client_secret: payment.client_secret,
          payment_intent_id: payment.id,
          transaction_id: transaction.id
        }, status: :created
      rescue StripePaymentService::ServiceError => error
        render json: { error: error.message }, status: :bad_gateway
      end

      def webhook
        payload = request.raw_post
        signature = request.env["HTTP_STRIPE_SIGNATURE"]

        event = StripePaymentService.new.parse_webhook(payload, signature)

        payment_intent = event.data.object
        transaction = PaymentTransaction.find_by(provider_payment_id: payment_intent.id)

        case event.type
        when "payment_intent.succeeded"
          transaction&.update(status: "succeeded", metadata: transaction.metadata.merge(event_type: event.type))
          booking = transaction&.booking
          booking&.update(status: "paid")

          send_payment_success_message(booking)
        when "payment_intent.payment_failed"
          transaction&.update(status: "failed", metadata: transaction.metadata.merge(event_type: event.type))
        when "payment_intent.canceled"
          transaction&.update(status: "cancelled", metadata: transaction.metadata.merge(event_type: event.type))
        end

        render json: { received: true }, status: :ok
      rescue StripePaymentService::ServiceError => error
        render json: { error: error.message }, status: :bad_request
      end

      private

      def send_payment_success_message(booking)
        return if booking.blank?

        phone = ENV["DEFAULT_CUSTOMER_WHATSAPP"]
        return if phone.blank?

        message = "Payment received for booking ##{booking.id}. Your Zanzibar trip is confirmed."
        WhatsappNotificationService.new.send_text(phone_number: phone, message: message)
      rescue StandardError => error
        Rails.logger.warn({ event: "whatsapp_notification_failed", message: error.message }.to_json)
      end
    end
  end
end
