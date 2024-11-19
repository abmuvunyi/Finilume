
# config/routes.rb

Rails.application.routes.draw do
  # Admin routes
  draw :madmin
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
authenticate :user, lambda { |u| u.admin? } do
  mount Sidekiq::Web => '/sidekiq'

  namespace :madmin do
    resources :impersonates do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
    end
  end
end

  # Admin Dashboard routes
  namespace :admin do
    resources :data_access_requests, only: [:index, :update]
  end

  # FSP Dashboard routes
  namespace :fsp_dashboard do
    get 'view_business/:id', to: 'fsp_dashboard#view_business', as: 'view_business'
    post 'request_data_access/:id', to: 'fsp_dashboard#request_data_access', as: 'request_data_access'
  end

  # Devise configurations for different users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions',  registrations: 'users/registrations', passwords: 'users/passwords', confirmations: 'users/confirmations', unlocks: 'users/unlocks'}
  devise_for :fsp_users, path: 'fsp', controllers: {
    sessions: 'fsp_users/sessions',
    registrations: 'fsp_users/registrations',
    passwords: 'fsp_users/passwords',
    confirmations: 'fsp_users/confirmations',
    unlocks: 'fsp_users/unlocks'
  }

  # Dashboard and main pages routes
  get "dashboard/index"
  resources :incomes
  resources :expenses
  resources :sales
  resources :products


  # Announcements and notifications
  resources :notifications, only: [:index]
  resources :announcements, only: [:index]

  # Root paths
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  authenticated :fsp_user do
    root to: 'fsp_dashboard/fsp_dashboard#index', as: :authenticated_fsp_root
  end

  # Default root
  root to: 'home#index'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  get 'dashboard/download_pdf', to: 'dashboard#download_pdf', as: :download_pdf

end
