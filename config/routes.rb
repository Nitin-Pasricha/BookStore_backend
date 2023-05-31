
Rails.application.routes.draw do
  
  # require 'sidekiq/web'
  # BookStore::Application.routes.draw do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # routes for book store

  get 'stores', to:'stores#index'
  post 'stores', to:'stores#create'
  get 'stores/show/:id', to: 'stores#show'
  post 'stores/update/:id', to: 'stores#update'
  delete 'stores/destroy/:id', to: 'stores#destroy'

  # routes for order items

  post 'add_to_cart/:store_id', to: 'order_items#add_to_cart'
  delete 'order_items/destroy/:id', to: 'order_items#destroy'

  # routes for cart

  get 'cart', to: 'cart#index'
  delete 'empty_cart', to: 'cart#empty_cart'
  post 'checkout', to: 'cart#checkout'

  # route for checking order history

  get 'order_history', to: 'order_history#index'
  get 'order_details/:order_id', to: 'order_history#order_details'


  # routes for authentication of user

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
