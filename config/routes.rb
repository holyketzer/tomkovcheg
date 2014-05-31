Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', registration: 'account', sign_up: 'register' }
  root to: 'site#index'

  resources :categories
  resources :articles

  resources :images, only: :destroy
end
