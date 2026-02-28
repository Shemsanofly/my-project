module Api
  module V1
    class PaymentTransactionsController < ApplicationController
      before_action :authenticate_user!

      def index
        transactions = current_user.payment_transactions.order(created_at: :desc)
        render json: transactions
      end

      def show
        transaction = current_user.payment_transactions.find(params[:id])
        render json: transaction
      end
    end
  end
end
