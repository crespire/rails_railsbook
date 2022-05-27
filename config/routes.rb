Rails.application.routes.draw do
  devise_for :users

  resources :posts, shallow: true do
    resources :comments
  end

  root "posts#index"
end
