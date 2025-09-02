Rails.application.routes.draw do
  # OmniAuth callbacks outside locale scope
  devise_for :users, only: [:omniauth_callbacks], controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # ✅ Madmin outside locale scope
  draw :madmin

  scope "(:locale)", locale: /en|rw/ do
    get "/privacy", to: "home#privacy"
    get "/terms",   to: "home#terms"

    # Admin routes (still localized if you want them)
    namespace :admin do
      resources :data_access_requests, only: [:index, :update]
      resources :feedbacks, only: [:index, :show, :update]
    end

    namespace :fsp_dashboard do
      get "view_business/:id",        to: "fsp_dashboard#view_business",   as: "view_business"
      post "request_data_access/:id", to: "fsp_dashboard#request_data_access", as: "request_data_access"
    end

    devise_for :users, skip: [:omniauth_callbacks], controllers: {
      sessions:      "users/sessions",
      registrations: "users/registrations",
      passwords:     "users/passwords",
      confirmations: "users/confirmations",
      unlocks:       "users/unlocks"
    }

    devise_for :fsp_users, path: "fsp", controllers: {
      sessions:      "fsp_users/sessions",
      registrations: "fsp_users/registrations",
      passwords:     "fsp_users/passwords",
      confirmations: "fsp_users/confirmations",
      unlocks:       "fsp_users/unlocks"
    }

    get "dashboard/index"
    get "dashboard/download_pdf", to: "dashboard#download_pdf", as: :download_pdf

    resources :incomes
    resources :expenses
    resources :sales
    resources :products

    resources :notifications, only: [:index]
    resources :announcements, only: [:index]

    # ✅ Feedback form inside locale
    resources :feedbacks, only: [:new, :create]

    authenticated :user do
      root to: "dashboard#index", as: :authenticated_root
    end
    authenticated :fsp_user do
      root to: "fsp_dashboard/fsp_dashboard#index", as: :authenticated_fsp_root
    end

    root to: "home#index"
  end

  # Healthcheck outside locale
  get "up" => "rails/health#show", as: :rails_health_check
end
