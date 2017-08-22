Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  namespace :admin do
     resources :surfcamps, only: [:new, :create]
  end
  resources :surfcamps, only: [:index, :show] do
    resources :bookings, only: [:create]
  end
  resources :bookings, only: [:show]
  mount Attachinary::Engine => "/attachinary"
end
