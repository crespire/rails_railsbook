Rails.application.routes.draw do
  devise_for :users

  resources :posts, shallow: true do
    resources :comments
  end

  resources :users, only: %i[show], shallow: true do
    resources :requests
    resources :notifications
  end

  root "posts#index"
end
