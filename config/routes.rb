Rails.application.routes.draw do
  devise_for :users
  root to: "farms#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :farms

  resources :carts, except: %i[new create] do
    resources :cart_chemicals, only: %i[new create]
  end

  resources :cart_chemicals, only: %i[destroy]

  resources :storages do
    resources :carts, only: %i[new create]
  end

  patch "carts/:id/record" => 'carts#record', as: "cart_record"

  resources :chemicals
  resources :employees
  get "myjobs" => "employees#myjobs"

  get "pending" => "carts#pending"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "myfarms" => 'farms#myfarms'
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
