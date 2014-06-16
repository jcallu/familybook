Rails.application.routes.draw do
  get 'header/_header'

  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords"}

  root to: "home#index"

  get 'follow' => 'users#follow'
  get 'unfollow' => 'users#unfollow'

  get 'like' => 'users#like'
  get 'unlike' => 'users#unlike'

  get 'family_request_sent' => 'families#family_request_sent'
  get 'family_request_pending' => 'families#family_request_pending'
  get 'family_request_delete' => 'families#family_request_delete'

  resources :posts
  resources :users
  resources :comments
  resources :likes
  resources :families

end
