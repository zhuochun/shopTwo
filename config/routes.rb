ServerRails::Application.routes.draw do
  devise_for :users

  resources :users do
    collection do
      get 'employee'
      get 'manager'
    end
  end

  resources :stores do
    resources :settlements, only: [:index, :show]
    resources :stocks, only: [:index]

    member do
      patch 'reopen'
    end
  end

  resources :stocks do
    collection do
      get 'mass', to: "stocks#restock"
      get 'download'
      get 'batch_new'
      post 'batch_create'
    end
  end

  # transactions
  resources :settlements do
    member do
      get 'search'
    end
  end

  resources :products do
    collection do
      get 'batch_new'
      post 'batch_create'
      post 'active_pricing'
    end

    member do
      patch 'update_price'
    end

    resources :stocks, only: [:new]
  end
  resources :manufacturers
  resources :categories
  resources :comments

  # online shop
  resources :carts
  resources :orders
  resources :line_items

  # custom pages
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'
  get '/deals', to: 'home#today_deals', as: 'deals'
  get '/search', to: 'home#search', as: 'search'

  # api price_lists
  get  '/api/:store_id/price_list', to: 'api#price_list'
  # api transactions/settlements
  post '/api/:store_id/transaction', to: 'api#settlement'
  # api members
  get  '/api/members', to: 'api#members'
  post '/api/:store_id/members', to: 'api#member_spendings'

  root 'home#index'
end
