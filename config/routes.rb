Rails.application.routes.draw do
  get "experts/index"
  get "users/index"
  get "users/show"
  get "users/edit"
  get "users/update"
  get "settings/index"
  get "settings/edit"
  get "settings/update"
  get "content/index"
  get "marks/index"
  get "marks/show"
  get "themes/index"
  get "themes/show"

  root to: 'user#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'user#new', as: 'register'
  post '/register', to: 'user#create'

  resources :themes, only: [:index, :show]
  resources :marks, only: [:index, :show]
  resources :content, only: [:index]
  resources :settings, only: [:index, :edit, :update]
  resources :users, only: [:index, :show, :edit, :update]
  resources :experts, only: [:index]

  get '/user', to: 'user#index', constraints: ->(req) { req.session[:session_token].present? }

  get '/api/sessions/list', to: 'sessions#list', constraints: ->(req) { req.session[:session_token].present? }

  get '/settings/language/:locale', to: 'application#switch_locale', as: 'switch_locale'
  post '/settings/update_language', to: 'settings#update_language', as: 'update_language_settings'

  # default route
  get "up" => "rails/health#show", as: :rails_health_check
end
