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
  end

  resources :stocks do
    collection do
      get 'download'
    end
  end
  # alias to transactions
  resources :settlements

  resources :products do
    collection do
      get 'batch_new'
      post 'batch_create'
    end

    member do
      patch 'update_price'
    end

    resources :stocks, only: [:new]
  end
  resources :manufacturers
  resources :categories

  # custom pages
  get '/dashboard', to: 'home#dashboard', as: 'dashboard'
  get '/deals', to: 'home#today_deals', as: 'deals'
  get '/search', to: 'home#search', as: 'search'

  # api gets
  get '/api/customers', to: 'api#customers'
  get '/api/price_list', to: 'api#price_list'
  get '/api/stores/:store_id/price_list', to: 'api#price_list'
  # api posts
  post '/api/transaction', to: 'api#settlement'
  post '/api/stores/:store_id/transaction', to: 'api#settlement'

  root 'home#index'
end
