Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  resources :users, only: [] do
    resources :bets, only: [:index]
  end
  get 'home/index'
  resources :games, only: [:index, :edit, :update]
end
