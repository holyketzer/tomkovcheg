Rails.application.routes.draw do
  root to: 'articles#index'

  resources :categories
  resources :articles
end
