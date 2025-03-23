Rails.application.routes.draw do
  get "grades/index"
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
  get "topics/index"
  get "topics/show"

  root to: 'user#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/register', to: 'user#new', as: 'register'
  post '/register', to: 'user#create'

  resources :topics, only: [:new, :index, :show, :edit, :update, :create, :destroy] do
    member do
      get 'add_photo'
      post 'add_photo'
      delete 'delete_photo/:attachment_id', to: 'topics#delete_photo', as: 'delete_photo'
    end
  end
  resources :marks, only: [:index, :show] do
    member do
      post 'vote'
    end
  end

  resources :grades, only: [:index]
  resources :content, only: [:index, :destroy]
  resources :settings, only: [:index, :edit, :update]
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :experts, only: [:index]

  get '/user', to: 'user#index', constraints: ->(req) { req.session[:session_token].present? }
  get '/user/:id', to: 'user#show', constraints: ->(req) { req.session[:session_token].present? }
  patch '/user', to: 'user#update'

  get '/api/sessions/list', to: 'sessions#list', constraints: ->(req) { req.session[:session_token].present? }

  get '/settings/language/:locale', to: 'application#switch_locale', as: 'switch_locale'
  post '/settings/update_language', to: 'settings#update_language', as: 'update_language_settings'
  delete '/api/user/photo/remove', to: 'user#remove_photo'

  post '/api/attachment/create', to: 'attachment#create', as: 'create_attachment'
  get '/api/attachment/show', to: 'attachment#show', as: 'show_attachment'

  # default route
  get "up" => "rails/health#show", as: :rails_health_check
end
