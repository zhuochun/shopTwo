ServerRails::Application.routes.draw do
  devise_for :users

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

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
