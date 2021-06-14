Rails.application.routes.draw do
  get 'users/show'
  get 'users/index'
  devise_for :users
  root to:'home#top'
  get 'home/about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books, only: [:edit, :create, :index, :show, :destroy,:update,:destroy]
  resources :users, only: [:show, :index, :edit,:update]
end
