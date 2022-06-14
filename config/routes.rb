Rails.application.routes.draw do
  devise_for :users

  resources :posts, shallow: true do
    resources :comments
  end

  resources :users, only: %i[show], shallow: true do
    resources :requests, only: %i[index create update destroy]
    resources :notifications
  end

  root 'posts#index'
  get '/search', to: 'users#search'
end
