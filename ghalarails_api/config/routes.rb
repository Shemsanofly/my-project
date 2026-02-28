Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "health", to: "health#show"

      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      resources :tours, only: %i[index show]
      resources :itineraries, only: %i[index show create]
      resources :bookings
      resources :payment_transactions, only: %i[index show]

      post "payments/create_intent", to: "payments#create_intent"
      post "payments/webhook", to: "payments#webhook"

      namespace :admin do
        resources :tours
      end
    end
  end
end
