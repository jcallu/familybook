Rails.application.routes.draw do
  get 'header/_header'
  
  devise_for :users, :controllers => {:registrations => "users/registrations", :passwords => "users/passwords"}

  root to: "home#index"

  get 'follow' => 'users#follow'
  get 'unfollow' => 'users#unfollow'

  get 'like' => 'users#like'
  get 'unlike' => 'users#unlike'

  get 'group_request_sent' => 'groups#group_request_sent'
  get 'group_request_pending' => 'groups#group_request_pending'
  get 'group_request_delete' => 'groups#group_request_delete'

  get 'groups/member_requests' => 'groups#member_requests'

  get 'group_accept_received' => 'groups#group_accept_received'
  get 'group_accept_confirmed' => 'groups#group_accept_confirmed'



  resources :posts
  resources :users
  resources :comments
  resources :likes
  resources :groups

  get "*path" => redirect("/")
end
