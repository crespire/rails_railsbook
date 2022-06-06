Rails.application.routes.draw do
  devise_for :users

  resources :posts, shallow: true do
    resources :comments
  end

  # Is there a way to get this testing without also declaring resources :users?
  resources :users, shallow: true do
    resources :requests
    resources :notifications
  end

  root "posts#index"
end
