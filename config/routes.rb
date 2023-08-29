Rails.application.routes.draw do
  resources :microposts
  resources :users
  root "users#index"

  get '/users/new', to: 'users#new', as: 'new_user'
end
