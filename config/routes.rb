Rails.application.routes.draw do

  get 'users/show'
  get 'users/index'
  devise_for :users
  root to:'home#top'
  get 'home/about'
  get 'books/category/:id'=>'books#category',as: 'book_category'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :books, only: [:edit, :create, :index, :show, :destroy,:update,:destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :users, only: [:show,:edit,:update]
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]

  resources :users, only: [:show, :index, :edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  # get 'search' => 'books#search'
  get 'search' => 'searches#search'
end
