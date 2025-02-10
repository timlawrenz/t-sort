Rails.application.routes.draw do
  resources :series do
    member do
      get :top5
      get :statistics
    end
  end
  resources :pictures
  resources :relations

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "pictures#index"
end
