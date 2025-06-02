Rails.application.routes.draw do
  get "dashboards/ceo"
  get "dashboards/user"
  resources :user_activities
  resources :activities
  resources :payments
  resources :plans
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "ceo/dashboard", to: "dashboards#ceo", as: :ceo_dashboard
  get "users/dashboard", to: "dashboards#user", as: :users_dashboard
  resources :plans, only: [:index, :show] do
    post 'subscribe', on: :member
  end
  
# Ruta raíz (por si quieres que lleve a login si no está logueado)
  root to: "plans#index"
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
