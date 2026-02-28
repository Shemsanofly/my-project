module Api
  module V1
    class ItinerariesController < ApplicationController
      before_action :authenticate_user!, only: %i[index show]
      before_action :authenticate_user_optional!, only: %i[create]

      def index
        itineraries = current_user.itineraries.order(created_at: :desc)
        render json: itineraries
      end

      def show
        itinerary = current_user.itineraries.find(params[:id])
        render json: itinerary
      end

      def create
        payload = itinerary_input
        generated = OpenaiItineraryService.new.generate(
          budget: payload[:budget],
          days: payload[:days],
          trip_type: payload[:trip_type],
          notes: payload[:notes]
        )

        itinerary = Itinerary.create!(
          user_id: current_user&.id,
          budget: payload[:budget],
          days: payload[:days],
          trip_type: payload[:trip_type],
          content: generated,
          metadata: { source: "openai", notes: payload[:notes] }
        )

        render json: itinerary, status: :created
      rescue OpenaiItineraryService::ServiceError => error
        render json: { error: error.message }, status: :bad_gateway
      end

      private

      def itinerary_input
        params.require(:itinerary).permit(:budget, :days, :trip_type, :notes)
      end
    end
  end
end
