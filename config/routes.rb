Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', registration: 'account', sign_up: 'register' }, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'account', to: 'registrations#show'
  end

  root to: 'site#index'
  get 'manage', to: 'site#manage'

  resources :articles do
    resources :comments, only: [:create, :destroy]
    resources :images, only: [:destroy]
  end

  resources :categories

  resources :galleries do
    resources :images, only: [:create, :destroy]
  end

  resources :roles, only: [:index, :show] do
    resources :permissions, only: [:index, :create, :destroy]
  end
end
