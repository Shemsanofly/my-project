module Api
  module V1
    class AuthController < ApplicationController
      def register
        user = User.create!(register_params)
        token = JwtService.encode(user_id: user.id)

        render json: {
          message: "User registered successfully",
          token: token,
          user: user.slice(:id, :name, :email)
        }, status: :created
      end

      def login
        user = User.find_by!(email: params.require(:email))

        unless user.authenticate(params.require(:password))
          return render json: { error: "Invalid email or password" }, status: :unauthorized
        end

        token = JwtService.encode(user_id: user.id)
        render json: {
          token: token,
          user: user.slice(:id, :name, :email)
        }
      end

      private

      def register_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
