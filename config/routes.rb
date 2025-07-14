Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Recursos principales
  resources :cities
  resources :gym_locations
  resources :plans do
    post 'subscribe', on: :member
  end
  
  
  resources :payments
  resources :activities
  resources :rooms
  resources :staff_members
  resources :user_activities
  resources :class_sessions
  resources :reservations
  resources :attendances

  # Horarios de clases + reserva desde schedule
  resources :class_schedules do
    post 'reserve', on: :member
  end

  # Dashboards por rol
  get "dashboards/ceo", to: "dashboards#ceo", as: :ceo_dashboard
  get "dashboards/user", to: "dashboards#user", as: :users_dashboard

  # Rutas personalizadas con mapeo devise_scope
  devise_scope :user do
    authenticated :user do
      root to: "dashboards#redirect_by_role", as: :authenticated_root
    end

    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  # Ruta de salud
  get "up" => "rails/health#show", as: :rails_health_check
end
