Rails.application.routes.draw do
  get 'stores', to:'stores#index'
  post 'stores', to:'stores#create'
  get 'stores/show/:id', to: 'stores#show'
  post 'stores/update/:id', to: 'stores#update'
  delete 'stores/destroy/:id', to: 'stores#destroy'


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
