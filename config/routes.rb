Rails.application.routes.draw do
  get 'sessions/new'
  root "static_pages#home"
  
  resources :microposts
  resources :users do
    member do
      get :edit
    end
  end
  
  get  "/help", to: "static_pages#help"
  get  "/about", to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"
  get '/users/new', to: 'users#new', as: 'users_new'

  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  
end
