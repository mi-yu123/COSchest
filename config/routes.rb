Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
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

  resources :costumes, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :wigs
  resources :contact_lenses
  resources :articles
  resources :settings
end
