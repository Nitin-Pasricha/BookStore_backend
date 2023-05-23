Rails.application.routes.draw do

  # routes for book store

  get 'stores', to:'stores#index'
  post 'stores', to:'stores#create'
  get 'stores/show/:id', to: 'stores#show'
  post 'stores/update/:id', to: 'stores#update'
  delete 'stores/destroy/:id', to: 'stores#destroy'

  # routes for line items

  post 'add_to_cart/:store_id', to: 'line_items#add_to_cart'
  delete 'line_items/destroy/:store_id', to: 'line_items#destroy'

  # routes for cart

  get 'cart', to: 'cart#index'
  delete 'empty_cart', to: 'cart#empty_cart'
  post 'checkout', to: 'cart#checkout'

  # route for checking order history

  get 'order_history', to: 'order_history#index'


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
