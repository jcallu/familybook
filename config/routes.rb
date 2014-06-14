Rails.application.routes.draw do
  get 'header/_header'

  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords"}

  root to: "home#index"

  get 'follow' => 'users#follow'
  get 'unfollow' => 'users#unfollow'
  get 'like' => 'users#like'
  get 'unlike' => 'users#unlike'

  get 'request_family_membership' => 'families#request_family_membership'

  resources :posts
  resources :users
  resources :comments
  resources :likes
  resources :families

end
