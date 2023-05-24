Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root "stories#index"
  
  put 'stories/:id/change_status', to: 'stories#change_status', as: 'change_status'

  resources :stories do
    resources :comments
  end

end
