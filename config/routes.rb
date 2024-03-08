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
  resources :carts, except: %i[new create] do
    resources :cart_chemicals, only: %i[new create]
  end

  resources :storages, except: [:index] do
    resources :carts, only: %i[new create]
  end
  get "my_storages" => "storages#my_storages"
  resources :chemicals
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "myfarms" => 'farms#myfarms'
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
