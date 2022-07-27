Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  concern :likeable do
    resources :likes, only: %i[create destroy]
  end

  resources :posts, shallow: true, concerns: :likeable do
    resources :comments, concerns: :likeable
  end

  resources :users, only: %i[index show], shallow: true do
    resources :requests, only: %i[index create update destroy]
  end

  delete 'users/:id', to: 'users#destroy'
  get 'search', to: 'users#search'
  get 'notifications', to: 'notifications#index'
  get 'requests', to: 'requests#index'
  get 'users/:id/requests', to: redirect('/requests')
  get 'credits', to: 'static_pages#credits'
  root 'posts#index'
end
