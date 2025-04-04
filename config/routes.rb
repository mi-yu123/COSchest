Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get 'task_selection', to: 'pages#task_selection'

  resources :tasks do
    member do
      patch :toggle
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
  root "home#index"

  resources :costumes, except: [:show]
  resources :wigs, except: [:show]
  resources :contact_lenses, except: [:show]
  resources :articles
  resources :packing_lists
  resource :profile, only: [:show, :edit, :update]
end
