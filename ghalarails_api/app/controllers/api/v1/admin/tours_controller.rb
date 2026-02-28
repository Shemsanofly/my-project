module Api
  module V1
    module Admin
      class ToursController < ApplicationController
        before_action :authenticate_user!
        before_action :require_admin!
        before_action :set_tour, only: %i[show update destroy]

        def index
          render json: Tour.order(created_at: :desc)
        end

        def show
          render json: @tour
        end

        def create
          tour = Tour.create!(tour_params)
          render json: tour, status: :created
        end

        def update
          @tour.update!(tour_params)
          render json: @tour
        end

        def destroy
          @tour.destroy!
          head :no_content
        end

        private

        def set_tour
          @tour = Tour.find(params[:id])
        end

        def tour_params
          params.require(:tour).permit(:title, :description, :price, :duration_days, :trip_type, :active)
        end
      end
    end
  end
end
