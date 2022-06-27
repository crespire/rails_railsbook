Rails.application.routes.draw do
  devise_for :users

  concern :likeable do
    resources :likes, only: %i[create destroy]
  end

  resources :posts, shallow: true, concerns: :likeable do
    resources :comments, concerns: :likeable
  end

  resources :users, only: %i[show], shallow: true do
    resources :requests, only: %i[index create update destroy]
    resources :notifications
  end

  delete 'users/:id', to: 'users#destroy'
  get '/search', to: 'users#search'
  root 'posts#index'
end
