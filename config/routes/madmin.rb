# Below are the routes for madmin
namespace :madmin do
  namespace :active_storage do
    resources :variant_records
  end
  namespace :active_storage do
    resources :attachments
  end
  namespace :noticed do
    resources :events
  end
  resources :users
  namespace :noticed do
    resources :notifications
  end
  namespace :active_storage do
    resources :blobs
  end
  resources :announcements
  resources :services
  root to: "dashboard#show"
end
