Rails.application.routes.draw do

  root "static_pages#home"

  get  "/help",    to: "static_pages#help"
  get  "/about",   to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"

  # 7章
  get "/signup", to: "users#new"

  # 8章
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users

end
