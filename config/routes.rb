Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      get "/merchants",            to: "merchants#index"
      get "/merchants/find",       to: "merchants#find"
      get "/merchants/:id",        to: "merchants#show"
      post "/merchants",           to: "merchants#create"
      patch "/merchants/:id",      to: "merchants#update"
      delete "/merchants/:id",     to: "merchants#destroy"
    end
  end
  
  get "/api/v1/merchants/:id/items",              to: "api/v1/merchants_items#index"
  get '/api/v1/items/find_all',                   to: 'api/v1/items#find_all'
  get "/api/v1/items/:id/merchant",               to: "api/v1/items_merchant#index"
  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/customers#index"
  get "/api/v1/merchants/:merchant_id/invoices",  to: "api/v1/invoices#index"

  namespace :api do
    namespace :v1 do
      get "/items",                 to: "items#index"
      get "/items/:id",             to: "items#show"
      post "/items",                to: "items#create"
      put "/items/:id",             to: "items#update"
      delete "/items/:id",          to: "items#destroy"
    end
  end
end
