Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords"}

  root to: "home#index"
  get 'debug' => 'home#debug'
  get 'follow' => 'users#follow'
  get 'unfollow' => 'users#unfollow'
  get 'like' => 'users#like'
  get 'unlike' => 'users#unlike'

  resources :posts
  resources :users
  resources :comments
  resources :likes
end
