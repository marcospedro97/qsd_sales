Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :customers do
    get 'search', on: :collection
    resources :orders, only: %i[new create]
  end
  resources :orders, only: %i[index show edit update] do
    patch 'finish_cancel', on: :member
    get 'cancel', on: :member
    patch 'finish_cancel', on: :member
    patch 'approve', on: :member
  end
  resources :users, only: %w[index edit update]
end
