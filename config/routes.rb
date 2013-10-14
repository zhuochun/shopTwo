ServerRails::Application.routes.draw do
  devise_for :users

  resources :users do
    collection do
      get 'employee'
      get 'manager'
    end
  end

  resources :stores

  resources :products do
    collection do
      get 'batch_new'
      post 'batch_create'
    end
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
  # api posts
  post '/api/transaction', to: 'api#transactions'

  root 'home#index'
end
