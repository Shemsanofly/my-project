module Api
  module V1
    class ToursController < ApplicationController
      def index
        tours = Tour.where(active: true).order(created_at: :desc)
        render json: tours
      end

      def show
        tour = Tour.find(params[:id])
        render json: tour
      end
    end
  end
end
