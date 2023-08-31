Rails.application.routes.draw do
  root "static_pages#home"
  
  resources :microposts
  resources :users
  
  get  "/help", to: "static_pages#help"
  get  "/about", to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"
  get '/users/new', to: 'users#new', as: 'users_new'
end
