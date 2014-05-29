Rails.application.routes.draw do
  root to: 'site#index'

  resources :categories
  resources :articles

  resources :images, only: :destroy
end
