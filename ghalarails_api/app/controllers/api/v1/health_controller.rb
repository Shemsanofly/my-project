module Api
  module V1
    class HealthController < ApplicationController
      def show
        render json: {
          status: "ok",
          service: "ghalarails_api",
          timestamp: Time.current
        }
      end
    end
  end
end
