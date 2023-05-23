Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root "stories#index"

  resources :organization do
    resources :stories do
      resources :comments
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
