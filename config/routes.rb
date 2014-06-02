Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"

  get 'follow' => 'users#follow'
  get 'unfollow' => 'users#unfollow'
  get 'like' => 'users#like'
  get 'unlike' => 'users#unlike'

  resources :posts
  resources :users
  resources :comments
  resources :likes
  resources :follows
end
