Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root "stories#index"

  patch 'organization/:organization_id/stories/:id/approve', to: 'stories#approve', as: 'approve'
  patch 'organization/:organization_id/stories/:id/request_changes', to: 'stories#request_changes', as: 'request_changes'
  patch 'organization/:organization_id/stories/:id/request_review', to: 'stories#request_review', as: 'request_review'

  resources :organization do
    resources :stories do
      resources :comments
    end
  end

end
