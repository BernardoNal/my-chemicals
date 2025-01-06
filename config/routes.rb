Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "farms#index"
  resources :farms
  get "myfarms" => 'farms#myfarms'

  resources :activities do
    resources :activity_chemicals, only: %i[new create]
    resources :responsibles, only: %i[new create]
  end

  resources :activity_chemicals, only: %i[destroy]
  resources :responsibles, only: %i[destroy]
  # namespace :activities do
  #   resources :activities
  # end

  resources :chemicals

  resources :storages do
    resources :carts, only: %i[new create]
  end

  resources :carts, except: %i[new create] do
    resources :cart_chemicals, only: %i[new create]
  end

  patch "carts/:id/record" => 'carts#record', as: "cart_record"
  get "pending" => "carts#pending"

  resources :cart_chemicals, only: %i[destroy]

  resources :employees
  get "myjobs" => "employees#myjobs"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
