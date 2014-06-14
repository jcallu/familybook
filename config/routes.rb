Rails.application.routes.draw do
  get 'header/_header'

  put "/" => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords"}

  root to: "home#index"

  get 'follow' => 'users#follow'
  get 'unfollow' => 'users#unfollow'
  get 'like' => 'users#like'
  get 'unlike' => 'users#unlike'

  resources :posts
  resources :users
  resources :comments
  resources :likes
  resources :families

end
