module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_booking, only: %i[show update destroy]

      def index
        render json: current_user.bookings.includes(:itinerary).order(created_at: :desc)
      end

      def show
        render json: @booking
      end

      def create
        booking = current_user.bookings.create!(booking_params)
        render json: booking, status: :created
      end

      def update
        @booking.update!(booking_params)
        render json: @booking
      end

      def destroy
        @booking.destroy!
        head :no_content
      end

      private

      def set_booking
        @booking = current_user.bookings.find(params[:id])
      end

      def booking_params
        params.require(:booking).permit(:itinerary_id, :tour_id, :start_date, :end_date, :guests, :status, :special_requests, :total_amount)
      end
    end
  end
end
