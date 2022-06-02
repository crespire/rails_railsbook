Rails.application.routes.draw do
  devise_for :users

  resources :posts, shallow: true do
    resources :comments
    resources :notifications
  end

  root "posts#index"
end
