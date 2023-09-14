Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Defines the root path route ("/")
  root 'home#index'

  resources :users, only: [:show] do
    resources :bets, only: [:index]
  end
  get 'home/index'
  resources :games, only: [:index, :edit, :update]
end
