Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'
  resources :microposts
  resources :users
  root "users#index"

  get '/users/new', to: 'users#new', as: 'new_user'
end
