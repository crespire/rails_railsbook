Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  concern :likeable do
    resources :likes, only: %i[create destroy]
  end

  resources :posts, shallow: true, concerns: :likeable do
    resources :comments, concerns: :likeable
  end

  resources :users, only: %i[show], shallow: true do
    resources :requests, only: %i[index create update destroy]
  end

  delete 'users/:id', to: 'users#destroy'
  get 'search', to: 'users#search'
  get 'notifications', to: 'notifications#index'
  get 'profile', to: 'users#show'
  root 'posts#index'
end
