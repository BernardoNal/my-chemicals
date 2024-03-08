Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :farms do
    member do
      get 'storages', to: 'farms#storages'
    end

    resources :storages, only: [:index] do
      member do
        get 'carts', to: 'farms#carts'
      end
    end
  end

  resources :storages, except: [:index]
  get "my_storages" => "storages#my_storages"
  resources :chemicals

  resources :cart_chemicals
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "myfarms" => 'farm#myfarms'
  # Defines the root path route ("/")
  # root "posts#index"
end
