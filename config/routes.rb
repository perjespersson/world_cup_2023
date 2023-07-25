Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'bets#index'

  resources :bets, only: [:index]
  get '/bets/user_bets/:id', to: 'bets#user_bets', as: 'user_bets'
  resources :games, only: [:index, :edit, :update]
end
